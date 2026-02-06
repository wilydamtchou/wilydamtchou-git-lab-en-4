package com.example.demopipeline;

import org.springframework.stereotype.Service;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.IOException;

@Service
public class DeploymentService {

    /**
     * Execute deployment DEV script
     * @return the result of script execution
     * @throws IOException if E/S error occurs
     * @throws InterruptedException if the process is interrupted
     */
    public String executeDeployDevScript() throws IOException, InterruptedException {
        ProcessBuilder processBuilder = new ProcessBuilder("bash", "scripts/deploy-dev.sh");
        processBuilder.directory(new java.io.File(System.getProperty("user.dir")));

        // Redirect error stream to capture both stdout and stderr
        processBuilder.redirectErrorStream(true);

        Process process = processBuilder.start();

        BufferedReader reader = new BufferedReader(
            new InputStreamReader(process.getInputStream())
        );

        StringBuilder output = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            output.append(line).append("\n");
        }

        int exitCode = process.waitFor();

        if (exitCode != 0) {
            throw new RuntimeException("Le script a échoué avec le code de sortie : " + exitCode);
        }

        return output.toString();
    }

    /**
     * Exécute deployment QA script
     * @return the result of script execution
     * @throws IOException if E/S error occurs
     * @throws InterruptedException if the process is interrupted
     */
    public String executeDeployQaScript() throws IOException, InterruptedException {
        ProcessBuilder processBuilder = new ProcessBuilder("bash", "scripts/deploy-qa.sh");
        processBuilder.directory(new java.io.File(System.getProperty("user.dir")));

        processBuilder.redirectErrorStream(true);

        Process process = processBuilder.start();

        BufferedReader reader = new BufferedReader(
            new InputStreamReader(process.getInputStream())
        );

        StringBuilder output = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            output.append(line).append("\n");
        }

        int exitCode = process.waitFor();

        if (exitCode != 0) {
            throw new RuntimeException("Script failed with exit code: " + exitCode);
        }

        return output.toString();
    }
}
