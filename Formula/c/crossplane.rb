class Crossplane < Formula
  desc "Build control planes without needing to write code"
  homepage "https:github.comcrossplanecrossplane"
  url "https:github.comcrossplanecrossplanearchiverefstagsv1.19.1.tar.gz"
  sha256 "254d93eccab65904c8f4572ef7878c95d96a0cd7cc509d0050396960e7b4b89f"
  license "Apache-2.0"
  head "https:github.comcrossplanecrossplane.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0097f1f2198e3c77e240942c7479408ce791d29d1c21071839ad88a52c1aab3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0097f1f2198e3c77e240942c7479408ce791d29d1c21071839ad88a52c1aab3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a0097f1f2198e3c77e240942c7479408ce791d29d1c21071839ad88a52c1aab3"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4cba58169c84389b8830fd7ac8ead6bccee3303970a0898d8fff82b8bb337c5"
    sha256 cellar: :any_skip_relocation, ventura:       "c4cba58169c84389b8830fd7ac8ead6bccee3303970a0898d8fff82b8bb337c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c9923ddfa4d8b280aa9285b8f71c097ff58b29df0db14877a1417adcd0cf983"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.comcrossplanecrossplaneinternalversion.version=v#{version}"), ".cmdcrank"
  end

  test do
    assert_match "Client Version: v#{version}", shell_output("#{bin}crossplane version --client")

    (testpath"controllerconfig.yaml").write <<~YAML
      apiVersion: pkg.crossplane.iov1alpha1
      kind: ControllerConfig
      metadata:
       name: irsa
      spec:
       args:
         - --enable-external-secret-stores
    YAML
    expected_output = <<~YAML
      apiVersion: pkg.crossplane.iov1beta1
      kind: DeploymentRuntimeConfig
      metadata:
        name: irsa
      spec:
        deploymentTemplate:
          spec:
            selector: {}
            strategy: {}
            template:
              metadata:
              spec:
                containers:
                - args:
                  - --enable-external-secret-stores
                  name: package-runtime
                  resources: {}
    YAML
    system bin"crossplane", "beta", "convert", "deployment-runtime", "controllerconfig.yaml", "-o",
"deploymentruntimeconfig.yaml"
    inreplace "deploymentruntimeconfig.yaml", ^\s+creationTimestamp.+$\n, ""
    assert_equal expected_output, File.read("deploymentruntimeconfig.yaml")
  end
end