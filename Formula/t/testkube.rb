class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.0.13.tar.gz"
  sha256 "e757e3345906b25896b8ab67b0aca18887e4ec192b2c98f7110ad0277469eccd"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "624ad728b3c8e185cbb1827f90ab8aad6b9d1d5e44a7b037e2e2d81aa2ad78b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10e54745a4353615d1fe8199c5599366bf4f1c04533d159244c97172131d792b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf251316259dfdbdbfba49953403137fe62fe45abc5ba5bb3a2e355622997fc9"
    sha256 cellar: :any_skip_relocation, sonoma:         "486e8ee3be12eb68f22cfcd6307b97e6a968026760baef202b126b67f46894e6"
    sha256 cellar: :any_skip_relocation, ventura:        "d24a4b5436da6e2cff0b8a73cd29831e79ec61e5b188353f49501d4064b199f1"
    sha256 cellar: :any_skip_relocation, monterey:       "cb71888ab9ebd8a66c82b86b08624a510af7d3825084f1f7ada10164e28dd774"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "edededd99c9b4adeacf3d3537f85e3592b821e7ea54c0b195d09e67e566ca3ce"
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