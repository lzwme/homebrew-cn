class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.41.tar.gz"
  sha256 "d572e386850ccac4205a74c4d075a809a4d178d6d10a349bd2c96c4c92a0ec63"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9df54266aa69c86bfd92ea60ed0ef07b477c2d67f498a1313a5257d06e183280"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9df54266aa69c86bfd92ea60ed0ef07b477c2d67f498a1313a5257d06e183280"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9df54266aa69c86bfd92ea60ed0ef07b477c2d67f498a1313a5257d06e183280"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0306a77ecec2f8204edf7da77a15caaf88cd228674953e3de3a3b5fd2fece97"
    sha256 cellar: :any_skip_relocation, ventura:       "c0306a77ecec2f8204edf7da77a15caaf88cd228674953e3de3a3b5fd2fece97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ac806e50bbcc6ab57f98c81d0e15b2bc54cd27305b0c1369e145c5ea1de55be"
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