class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  # testkube should only be updated every 5 releases on multiples of 5
  url "https://ghproxy.com/https://github.com/kubeshop/testkube/archive/v1.10.10.tar.gz"
  sha256 "c99e7f6b1032d031b8b809f87819ee88179092e3252322f2f9440606a473d426"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d2b188357d2d47a7bbb5db83ec5c2af7d2bcad2815c6f7927b0b6ff500211a25"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0acda0eba0bbe2a7fca02bb651ed755680819480661356142abe1c0e2e7bc208"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d2b188357d2d47a7bbb5db83ec5c2af7d2bcad2815c6f7927b0b6ff500211a25"
    sha256 cellar: :any_skip_relocation, ventura:        "860ce90dc7cf625b5b4a3251b6231e3738e324c463a08e48f5f017c9df7e9733"
    sha256 cellar: :any_skip_relocation, monterey:       "af1242d0cec28409caf5253337f38cfb8fe3cbd95e5bd638affbee348f5c9ea0"
    sha256 cellar: :any_skip_relocation, big_sur:        "af1242d0cec28409caf5253337f38cfb8fe3cbd95e5bd638affbee348f5c9ea0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f05f54175202fae13236468e49abecb721d71b7ac3119cb0d179339d6b01c98"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.builtBy=#{tap.user}
    ]

    system "go", "build", *std_go_args(output: bin/"kubectl-testkube", ldflags: ldflags),
      "cmd/kubectl-testkube/main.go"

    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin/"kubectl-testkube", "completion")
  end

  test do
    output = shell_output("#{bin}/kubectl-testkube get tests 2>&1", 1)
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end