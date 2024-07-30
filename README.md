# to-do-app-with-docker-jerkins-ec2-prometheus-grafana

This tutorial shows how to deploy a simple app to Amplify through a Jerkins CICD pipeline, it covers the following topics:

- Building containers
- Using volumes to persist data
- Using bind mounts to support development
- Using container networking to support multi-container applications
- Creating Jerkins files, integrating Jenkins and GitHub
- Using Jerkins to automate build and deployments
- Deploy multi-docker container to EC2 and monitor using Grafana, Prometheus

## Getting Started

### Step-by-Step Process:

1. **Developed a Containerized To-Do List Application:**
   - The application code is maintained in a GitHub repository based on this project github.com/StefanScherer/getting-started/blob/master/docker-compose.yml
   - Application uses node base image and MySQL image with appropriate networking
   - Uses a docker-compose file

2. # Set Up GitHub Webhook:
   - Configured a webhook to trigger Jenkins upon new commits to the GitHub repository.

3. # Jenkins Setup on EC2:
   - Jenkins, an open-source automation server, was chosen for CI/CD due to its flexibility and self-hosting capabilities.
   - Jenkins pulls the latest code from GitHub, builds the Docker image, and pushes it to Docker Hub.
   - Install the following directly on the server Docker, Docker-compose, 
   - Install the following plugins on Jenkins; Github, docker pipeline, Git, build pipeline, etc. Ensure appropriate setup of Jenkins
   - Write scripts carefully, ensure secure and valid authentication credentials, and ensure adequate authorization to EC2 through IAM roles
   - Ensure credentials are handled securely

4. # Deployment to Second EC2 Server:
   - Jenkins sends necessary files (Dockerfile, Jenkinsfile, prometheus.yml) to another EC2 server.
   - Jenkins triggers a script on the second EC2 server to pull the Docker image from Docker Hub and start various containers.
   - Install Docker, Docker compose on the second server
   - Ensure containers are stooped and previous images are removed on the server before starting new once
   - Confirm application is running through <Server public IP>:3000

5. # Running Prometheus and Grafana:
   - Prometheus and Grafana run in Docker containers on the second EC2 server.
   - Prometheus extracts metrics like HTTP requests and CPU usage, stores these metrics and integrates with Grafana for visualization.
   - Confirm Prometheus and Grafana are running on HTTP://<IP server address>:9090 and HTTP://<IP server address>:4000 respectively

### Tools and Technologies:

- # Jenkins:
  - Open-source CI/CD tool.
  - Hosted on-premises, providing control over infrastructure.
  - Advantages: Customizable pipelines, extensive plugin ecosystem, and strong community support.

- # Prometheus and Grafana:
  - Open-source monitoring and visualization tools.
  - Prometheus scrapes and stores metrics.
  - Grafana visualizes metrics, creating insightful dashboards.

I will be writing more detailed documentation of the process on my blog, you should check it out with the link

### Why Jenkins?
Jenkins offers several advantages over cloud-based CI/CD tools like GitHub Actions, AWS Amplify, and TravisCI:
- **Customizability:** Highly customizable pipelines to suit any development workflow.
- **Control:** Full control over the CI/CD infrastructure, ensuring security and compliance.
- **Community Support:** Vast plugin ecosystem and active community support.

### Benefits of Automated Infrastructure:
- **Efficiency:** Automates repetitive tasks, reducing manual intervention.
- **Consistency:** Ensures consistent application builds and deployments.
- **Scalability:** Easily scalable to accommodate growing project needs.
- **Monitoring:** Continuous monitoring and alerting with Prometheus and Grafana ensure system health and performance.

By integrating these open-source tools, I created a robust, automated CI/CD pipeline that enhances development efficiency and system reliability. Feel free to reach out if you’re interested in discussing DevOps strategies or need help with similar projects!

If you have a question or suggestion, contact me on LinkedIn
https://linkedin.com/in/anorue-wilson

## Contributing

If you find typos or other issues with the tutorial, feel free to create a PR and suggest fixes!

If you have ideas on how to make the tutorial better or new content, please open an issue first before working on your idea. While we love input, we want to keep the tutorial scoped to newcomers.
As such, we may reject ideas for more advanced requests and don't want you to lose any work you might
have done. So, ask first and we'll gladly hear your thoughts!
