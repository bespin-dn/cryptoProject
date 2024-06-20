package com.crypto.demo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import software.amazon.awssdk.core.SdkBytes;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.kms.KmsClient;
import software.amazon.awssdk.services.kms.model.DecryptRequest;
import software.amazon.awssdk.services.kms.model.DecryptResponse;

import java.util.Base64;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/")
public class DecryptionController {

    private final KmsClient kmsClient;
    private final SecretsManagerService secretsManagerService;

    @Autowired
    public DecryptionController(@Value("${aws.region}") String region,
                                SecretsManagerService secretsManagerService) {
        this.kmsClient = KmsClient.builder()
                                  .region(Region.of(region))
                                  .build();
        this.secretsManagerService = secretsManagerService;
    }

    @PostMapping("/decrypt")
    @ResponseBody
    public Map<String, String> decrypt(@RequestBody Map<String, String> request) {
        String ciphertextString = request.get("ciphertext");
        String kmsKeyId = secretsManagerService.getSecret();
        SdkBytes ciphertextBytes = SdkBytes.fromByteArray(Base64.getDecoder().decode(ciphertextString));

        DecryptRequest decryptRequest = DecryptRequest.builder()
                .keyId(kmsKeyId)
                .ciphertextBlob(ciphertextBytes)
                .build();

        DecryptResponse decryptResponse = kmsClient.decrypt(decryptRequest);
        String plaintext = decryptResponse.plaintext().asUtf8String();

        Map<String, String> response = new HashMap<>();
        response.put("plaintext", plaintext);
        
        return response;
    }
}
