require "languagenode"

class Kubevious < Formula
  desc "Detects and prevents Kubernetes misconfigurations and violations"
  homepage "https:github.comkubeviouscli"
  url "https:registry.npmjs.orgkubevious-kubevious-1.0.62.tgz"
  sha256 "d6961f75fd5cd329c70ad5581aa148bb36364367eeae40c82a499bdcae38647f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ac3c8e3b7eea3982848c1d7d39f20e8a3486f5ca45ed163cfd7328afe2e69748"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac3c8e3b7eea3982848c1d7d39f20e8a3486f5ca45ed163cfd7328afe2e69748"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac3c8e3b7eea3982848c1d7d39f20e8a3486f5ca45ed163cfd7328afe2e69748"
    sha256 cellar: :any_skip_relocation, sonoma:         "7b68ec2a3f12842af1d837943008ac6db58a356669df33e393336a65bae41094"
    sha256 cellar: :any_skip_relocation, ventura:        "7b68ec2a3f12842af1d837943008ac6db58a356669df33e393336a65bae41094"
    sha256 cellar: :any_skip_relocation, monterey:       "7b68ec2a3f12842af1d837943008ac6db58a356669df33e393336a65bae41094"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94541fa917a9f52ef7cb859f25f941e6e98539590574ed7abb6eee6a834c3bb7"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    assert_match version.to_s,
      shell_output("#{bin}kubevious --version")

    (testpath"deployment.yml").write <<~EOF
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
    EOF

    assert_match "Lint Succeeded",
      shell_output("#{bin}kubevious lint #{testpath}deployment.yml")

    (testpath"bad-deployment.yml").write <<~EOF
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
    EOF

    assert_match "Lint Failed",
      shell_output("#{bin}kubevious lint #{testpath}bad-deployment.yml", 100)

    assert_match "Guard Succeeded",
      shell_output("#{bin}kubevious guard #{testpath}deployment.yml")

    assert_match "Guard Failed",
      shell_output("#{bin}kubevious guard #{testpath}bad-deployment.yml", 100)

    (testpath"service.yml").write <<~EOF
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
      shell_output("#{bin}kubevious guard #{testpath}service.yml", 100)

    assert_match "Guard Succeeded",
      shell_output("#{bin}kubevious guard #{testpath}service.yml #{testpath}deployment.yml")
  end
end