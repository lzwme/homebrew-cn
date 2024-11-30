class Crossplane < Formula
  desc "Build control planes without needing to write code"
  homepage "https:github.comcrossplanecrossplane"
  url "https:github.comcrossplanecrossplanearchiverefstagsv1.18.1.tar.gz"
  sha256 "9e2ec058278e1978f414026bb023f2384523671b9dc7a6f7964597eb073cdae6"
  license "Apache-2.0"
  head "https:github.comcrossplanecrossplane.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65aa58395cfed33bba2ccdcf7ea31d707732bf25d5c723ae7fbe696c369bb961"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65aa58395cfed33bba2ccdcf7ea31d707732bf25d5c723ae7fbe696c369bb961"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "65aa58395cfed33bba2ccdcf7ea31d707732bf25d5c723ae7fbe696c369bb961"
    sha256 cellar: :any_skip_relocation, sonoma:        "89fe3405af51f4ec8438976e74b4a6f737fe84f851079e9c0f1d07e4ccab3bfa"
    sha256 cellar: :any_skip_relocation, ventura:       "89fe3405af51f4ec8438976e74b4a6f737fe84f851079e9c0f1d07e4ccab3bfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90645de80fee8c8f81b7cc78873365a63e4901702ab6fe80f8abbfbe93474c8e"
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