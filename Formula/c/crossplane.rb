class Crossplane < Formula
  desc "Build control planes without needing to write code"
  homepage "https:github.comcrossplanecrossplane"
  url "https:github.comcrossplanecrossplanearchiverefstagsv1.17.2.tar.gz"
  sha256 "2358bc4a2fe945d64d5ae5d557464215a54de8a6fc8dedf30d11ad608de96b69"
  license "Apache-2.0"
  head "https:github.comcrossplanecrossplane.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a003fcc563083fc4f58571247f0680acd45cdcdcbea2cd4f1418576ef4111979"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a003fcc563083fc4f58571247f0680acd45cdcdcbea2cd4f1418576ef4111979"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a003fcc563083fc4f58571247f0680acd45cdcdcbea2cd4f1418576ef4111979"
    sha256 cellar: :any_skip_relocation, sonoma:        "1abfcba7ac9fd6ec5935b7c71b6d4214fe6e8b790389f1bbdadb504b6ee01a4e"
    sha256 cellar: :any_skip_relocation, ventura:       "1abfcba7ac9fd6ec5935b7c71b6d4214fe6e8b790389f1bbdadb504b6ee01a4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "802a36da364c1ab8d4eb739bb71c3ed78bfc161758ed8e9f5acc7729ff747a04"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.comcrossplanecrossplaneinternalversion.version=v#{version}"), ".cmdcrank"
  end

  test do
    assert_match "Client Version: v#{version}", shell_output("#{bin}crossplane version --client")

    (testpath"controllerconfig.yaml").write <<~EOS
      apiVersion: pkg.crossplane.iov1alpha1
      kind: ControllerConfig
      metadata:
       name: irsa
      spec:
       args:
         - --enable-external-secret-stores
    EOS
    expected_output = <<~EOS
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
    EOS
    system bin"crossplane", "beta", "convert", "deployment-runtime", "controllerconfig.yaml", "-o",
"deploymentruntimeconfig.yaml"
    inreplace "deploymentruntimeconfig.yaml", ^\s+creationTimestamp.+$\n, ""
    assert_equal expected_output, File.read("deploymentruntimeconfig.yaml")
  end
end