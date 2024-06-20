package com.crypto.demo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import software.amazon.awssdk.core.SdkBytes;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.kms.KmsClient;
import software.amazon.awssdk.services.kms.model.EncryptRequest;
import software.amazon.awssdk.services.kms.model.EncryptResponse;

import java.util.Base64;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/")
public class EncryptionController {

    private final KmsClient kmsClient;
    private final SecretsManagerService secretsManagerService;

    @Autowired
    public EncryptionController(@Value("${aws.region}") String region,
                                SecretsManagerService secretsManagerService) {
        this.kmsClient = KmsClient.builder()
                                  .region(Region.of(region))
                                  .build();
        this.secretsManagerService = secretsManagerService;
    }

    @PostMapping("/encrypt")
    @ResponseBody
    public Map<String, String> encrypt(@RequestBody Map<String, String> request) {
        String plaintext = request.get("plaintext");
        String kmsKeyId = secretsManagerService.getSecret();
        System.out.println("kmsKeyId: " + kmsKeyId);
        SdkBytes plaintextBytes = SdkBytes.fromUtf8String(plaintext);

        EncryptRequest encryptRequest = EncryptRequest.builder()
                .keyId(kmsKeyId)
                .plaintext(plaintextBytes)
                .build();

        EncryptResponse encryptResponse = kmsClient.encrypt(encryptRequest);
        String algorithm = encryptResponse.encryptionAlgorithm().toString();
        System.out.println("The Algorithm is " + algorithm + ".");

        SdkBytes ciphertextBytes = encryptResponse.ciphertextBlob();
        String ciphertextString = Base64.getEncoder().encodeToString(ciphertextBytes.asByteArray());

        Map<String, String> response = new HashMap<>();
        response.put("ciphertextString", ciphertextString);
        
        return response;
    }
}
