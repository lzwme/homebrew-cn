class DejaVu < Formula
  desc "Local searchable memory over the session histories of coding agents"
  homepage "https://github.com/vshulcz/deja-vu"
  url "https://ghfast.top/https://github.com/vshulcz/deja-vu/archive/refs/tags/v0.21.5.tar.gz"
  sha256 "96bd136f807af927e11180bb052ae3c1b47c73c39665d59a52089f8f5c9ad34b"
  license "MIT"
  head "https://github.com/vshulcz/deja-vu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bb7d9920d1b0274dab702721e46eb7a8b1591250bb60f638576bf48f682e86aa"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bb7d9920d1b0274dab702721e46eb7a8b1591250bb60f638576bf48f682e86aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bb7d9920d1b0274dab702721e46eb7a8b1591250bb60f638576bf48f682e86aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9954720a683339a81a02c363a752bcc72405b6f8b2246f6497a2500daf436840"
    sha256 cellar: :any,                 x86_64_linux:      "a02686437788ce99315c1c7160121f9fd01f7f9423728e09f8d700bb14e479b6"
  end

  depends_on "go" => :build

  deny_network_access! [:postinstall, :test]

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"deja"), "./cmd/deja"

    generate_completions_from_executable(bin/"deja", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/deja version")
    assert_match '"schema_version": 2', shell_output("#{bin}/deja doctor --json --offline")
    assert_match "no matches", shell_output("#{bin}/deja search nothing-is-indexed-here 2>&1")
  end
end