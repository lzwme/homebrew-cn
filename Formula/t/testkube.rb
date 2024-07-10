class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.0.6.tar.gz"
  sha256 "840f7cc13c0127f070eca746f4d359681090192e7540504640d799defd95f2c9"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d9c02e9776b8d9eee682836a57d63d56ac2dfe4191ba2362271ed436ea5c8672"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dbb15c3370c487801d807962db93c4017bc42d0e7e892985d294b9cd524da771"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "817299c85193636b2f14786d7e6899cb88634c86baf9e1abd3768bf3de5ab35b"
    sha256 cellar: :any_skip_relocation, sonoma:         "268e60d51df256017cd4dd6e1d7382b19dd9842559c60bff4d9338363982f80e"
    sha256 cellar: :any_skip_relocation, ventura:        "677f062aa456a955a0eff939a5ed8b3c513385fd3f94c645cad5f356c6a76951"
    sha256 cellar: :any_skip_relocation, monterey:       "83fab856fc08841a9ffcf5963f69ce7f9f566f95de020bcf490d12389757da5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59d8286df83a6650f79f89270cf6df820d540a88e4608c7590bb4ec1cc0e25f4"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.builtBy=#{tap.user}
    ]

    system "go", "build", *std_go_args(output: bin"kubectl-testkube", ldflags:),
      "cmdkubectl-testkubemain.go"

    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin"kubectl-testkube", "completion")
  end

  test do
    output = shell_output("#{bin}kubectl-testkube get tests 2>&1", 1)
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end