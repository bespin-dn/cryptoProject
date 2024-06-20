package com.crypto.demo;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.secretsmanager.SecretsManagerClient;
import software.amazon.awssdk.services.secretsmanager.model.GetSecretValueRequest;
import software.amazon.awssdk.services.secretsmanager.model.GetSecretValueResponse;

@Service
public class SecretsManagerService {

    private final SecretsManagerClient secretsManagerClient;
    private final String secretName;

    public SecretsManagerService(@Value("${aws.region}") String region, 
                                 @Value("${secretsmanager.secretName}") String secretName) {
        this.secretsManagerClient = SecretsManagerClient.builder()
                                                         .region(Region.of(region))
                                                         .build();
        this.secretName = secretName;
    }

    public String getSecret() {
        GetSecretValueRequest getSecretValueRequest = GetSecretValueRequest.builder()
                                                                           .secretId(secretName)
                                                                           .build();
        GetSecretValueResponse getSecretValueResponse = secretsManagerClient.getSecretValue(getSecretValueRequest);
        return getSecretValueResponse.secretString();
    }
}
