class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv1.16.22.tar.gz"
  sha256 "460e21fa12de76d54e20d412aed05d4dce90ebb8dea7bb7fb83e5e81cb7a05c3"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bd22fdb7404a6cc5bfab0302fd3cb75d292a9508023f085929f4051cc1411915"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b97c4e63fa0cae8636c32ffb4b27181ac569459a117e18b09ed5a478a50e486"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53a955ec8de29f4fb1516bde192a538f5367d860c8b56f8f87276b36728d62c2"
    sha256 cellar: :any_skip_relocation, sonoma:         "14a01b2cc1ca4b19de312834599056faae55ca6d41217ee1afdf709eeb28ceb6"
    sha256 cellar: :any_skip_relocation, ventura:        "def44aaf6be97fa17f0d46f6c4681120b0e957adeeaae1511d2a3bf02c8795ec"
    sha256 cellar: :any_skip_relocation, monterey:       "ac47cf6f7d1b9e48d955fe5c149450ea24ab3b8d495f8ceddbbba4c8de909e4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9e805b4b1758aff972df4b9c76127d17b9f9d17dd1c819c574131cf9bf0f484"
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

    system "go", "build", *std_go_args(output: bin"kubectl-testkube", ldflags: ldflags),
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