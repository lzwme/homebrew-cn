class Pluto < Formula
  desc "CLI tool to help discover deprecated apiVersions in Kubernetes"
  homepage "https:fairwinds.com"
  url "https:github.comFairwindsOpsplutoarchiverefstagsv5.21.0.tar.gz"
  sha256 "0b09aaa02da175c801c6635d15041b2ef02e165f730fc226cf4a0022aeadd32b"
  license "Apache-2.0"
  head "https:github.comFairwindsOpspluto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c360c51cd3baf00dbef4b0ed4f91e431eca3c438429fadeaa44db726e0c13ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c360c51cd3baf00dbef4b0ed4f91e431eca3c438429fadeaa44db726e0c13ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6c360c51cd3baf00dbef4b0ed4f91e431eca3c438429fadeaa44db726e0c13ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "50c0c25ce618d7b5af39d3f8986eb67aa677b654dba282749a90f0faf0426d2c"
    sha256 cellar: :any_skip_relocation, ventura:       "50c0c25ce618d7b5af39d3f8986eb67aa677b654dba282749a90f0faf0426d2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1e57325d146a752ea2fa47feeb710e03aa727affd4081f9d300c1c00dd42eed"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "cmdplutomain.go"
    generate_completions_from_executable(bin"pluto", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}pluto version")
    assert_match "Deployment", shell_output("#{bin}pluto list-versions")

    (testpath"deployment.yaml").write <<~YAML
      apiVersion: extensionsv1beta1
      kind: Deployment
      metadata:
        name: homebrew-test
      spec: {}
    YAML
    assert_match "homebrew-test", shell_output("#{bin}pluto detect deployment.yaml", 3)
  end
end