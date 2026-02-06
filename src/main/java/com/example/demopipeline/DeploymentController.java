package com.example.demopipeline;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/deployment")
public class DeploymentController {

    @Autowired
    private DeploymentService deploymentService;

    /**
     * Endpoint pour déployer l'environnement DEV
     * @return le résultat du déploiement
     */
    @PostMapping("/deploy-dev")
    public ResponseEntity<Map<String, Object>> deployDev() {
        Map<String, Object> response = new HashMap<>();
        try {
            String result = deploymentService.executeDeployDevScript();
            response.put("status", "success");
            response.put("environment", "DEV");
            response.put("output", result);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("status", "error");
            response.put("environment", "DEV");
            response.put("error", e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * Endpoint to deploy the QA environment
     * @return the deployment result
     */
    @PostMapping("/deploy-qa")
    public ResponseEntity<Map<String, Object>> deployQa() {
        Map<String, Object> response = new HashMap<>();
        try {
            String result = deploymentService.executeDeployQaScript();
            response.put("status", "success");
            response.put("environment", "QA");
            response.put("output", result);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("status", "error");
            response.put("environment", "QA");
            response.put("error", e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }
}
