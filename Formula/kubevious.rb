require "language/node"

class Kubevious < Formula
  desc "Detects and prevents Kubernetes misconfigurations and violations"
  homepage "https://github.com/kubevious/cli"
  url "https://registry.npmjs.org/kubevious/-/kubevious-1.0.55.tgz"
  sha256 "d2d9b27b097bf66be001f3f2ae72568fe0137894323c7d3c82bdd8f0e825dce5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b95fc0d8ca7f7b3534f8602b9790a737f125245786eb2ae7242e11db90cda624"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b95fc0d8ca7f7b3534f8602b9790a737f125245786eb2ae7242e11db90cda624"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b95fc0d8ca7f7b3534f8602b9790a737f125245786eb2ae7242e11db90cda624"
    sha256 cellar: :any_skip_relocation, ventura:        "33c308ab59dfc96c6f5b17139feb9df6f31a4135660851419e75e37c16d2490f"
    sha256 cellar: :any_skip_relocation, monterey:       "33c308ab59dfc96c6f5b17139feb9df6f31a4135660851419e75e37c16d2490f"
    sha256 cellar: :any_skip_relocation, big_sur:        "33c308ab59dfc96c6f5b17139feb9df6f31a4135660851419e75e37c16d2490f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b95fc0d8ca7f7b3534f8602b9790a737f125245786eb2ae7242e11db90cda624"
  end

  depends_on "node@18"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"kubevious").write_env_script libexec/"bin/kubevious", PATH: "#{Formula["node@18"].opt_bin}:$PATH"
  end

  test do
    assert_match version.to_s,
      shell_output("#{bin}/kubevious --version")

    (testpath/"deployment.yml").write <<~EOF
      apiVersion: apps/v1
      kind: Deployment
      metadata:
        name: nginx
      spec:
        selector:
          matchLabels:
            app: nginx
        replicas: 1
        template:
          metadata:
            labels:
              app: nginx
          spec:
            containers:
            - name: nginx
              image: nginx:1.14.2
              ports:
              - containerPort: 80
    EOF

    assert_match "Lint Succeeded",
      shell_output("#{bin}/kubevious lint #{testpath}/deployment.yml")

    (testpath/"bad-deployment.yml").write <<~EOF
      apiVersion: apps/v1
      kind: BadDeployment
      metadata:
        name: nginx
      spec:
        selector:
          matchLabels:
            app: nginx
        replicas: 1
        template:
          metadata:
            labels:
              app: nginx
          spec:
            containers:
            - name: nginx
              image: nginx:1.14.2
              ports:
              - containerPort: 80
    EOF

    assert_match "Lint Failed",
      shell_output("#{bin}/kubevious lint #{testpath}/bad-deployment.yml", 100)

    assert_match "Guard Succeeded",
      shell_output("#{bin}/kubevious guard #{testpath}/deployment.yml")

    assert_match "Guard Failed",
      shell_output("#{bin}/kubevious guard #{testpath}/bad-deployment.yml", 100)

    (testpath/"service.yml").write <<~EOF
      apiVersion: v1
      kind: Service
      metadata:
        labels:
          app: nginx
        name: nginx
      spec:
        type: ClusterIP
        ports:
        - name: http
          port: 80
          targetPort: 8080
        selector:
          app: nginx
    EOF

    assert_match "Guard Failed",
      shell_output("#{bin}/kubevious guard #{testpath}/service.yml", 100)

    assert_match "Guard Succeeded",
      shell_output("#{bin}/kubevious guard #{testpath}/service.yml #{testpath}/deployment.yml")
  end
end