class Crossplane < Formula
  desc "Build control planes without needing to write code"
  homepage "https:github.comcrossplanecrossplane"
  url "https:github.comcrossplanecrossplanearchiverefstagsv1.19.0.tar.gz"
  sha256 "b68b9867bb42df0782b9ef23fdfbd0b42f3fb3d142a8152414a7158dead28b6d"
  license "Apache-2.0"
  head "https:github.comcrossplanecrossplane.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dfa687c70d42a30eaee72e9ddae408f98c54bb172096c0aa3c69f19ddcaf21a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dfa687c70d42a30eaee72e9ddae408f98c54bb172096c0aa3c69f19ddcaf21a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dfa687c70d42a30eaee72e9ddae408f98c54bb172096c0aa3c69f19ddcaf21a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d98655c28ca5552dec17967d93f0a6b6dbd1f076495d88ba8b4fb75d5ecc282"
    sha256 cellar: :any_skip_relocation, ventura:       "1d98655c28ca5552dec17967d93f0a6b6dbd1f076495d88ba8b4fb75d5ecc282"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80caea326b2576025a62c4e071775388ae6b214deace59879bf7ac44070f48b6"
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