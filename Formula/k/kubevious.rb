class Kubevious < Formula
  desc "Detects and prevents Kubernetes misconfigurations and violations"
  homepage "https:github.comkubeviouscli"
  url "https:registry.npmjs.orgkubevious-kubevious-1.0.63.tgz"
  sha256 "b9a41e92d891385ee1c8edd140fbbd06bea1d6cbc2730b25f2dc618b140db8c5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6649285a0612dbbb94b3294d1a61b63847291626cb1cfabe317053be02caa5fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6649285a0612dbbb94b3294d1a61b63847291626cb1cfabe317053be02caa5fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6649285a0612dbbb94b3294d1a61b63847291626cb1cfabe317053be02caa5fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "6662e0e9b747da81e039e82d9cb3f26e972b83482e6fac21dff5325bcd8a639d"
    sha256 cellar: :any_skip_relocation, ventura:       "6662e0e9b747da81e039e82d9cb3f26e972b83482e6fac21dff5325bcd8a639d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6649285a0612dbbb94b3294d1a61b63847291626cb1cfabe317053be02caa5fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6649285a0612dbbb94b3294d1a61b63847291626cb1cfabe317053be02caa5fa"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    assert_match version.to_s,
      shell_output("#{bin}kubevious --version")

    (testpath"deployment.yml").write <<~YAML
      apiVersion: appsv1
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
    YAML

    assert_match "Lint Succeeded",
      shell_output("#{bin}kubevious lint #{testpath}deployment.yml")

    (testpath"bad-deployment.yml").write <<~YAML
      apiVersion: appsv1
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
    YAML

    assert_match "Lint Failed",
      shell_output("#{bin}kubevious lint #{testpath}bad-deployment.yml", 100)

    assert_match "Guard Succeeded",
      shell_output("#{bin}kubevious guard #{testpath}deployment.yml")

    assert_match "Guard Failed",
      shell_output("#{bin}kubevious guard #{testpath}bad-deployment.yml", 100)

    (testpath"service.yml").write <<~YAML
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
    YAML

    assert_match "Guard Failed",
      shell_output("#{bin}kubevious guard #{testpath}service.yml", 100)

    assert_match "Guard Succeeded",
      shell_output("#{bin}kubevious guard #{testpath}service.yml #{testpath}deployment.yml")
  end
end