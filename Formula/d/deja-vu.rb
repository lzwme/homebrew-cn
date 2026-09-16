class DejaVu < Formula
  desc "Local searchable memory over the session histories of coding agents"
  homepage "https://github.com/vshulcz/deja-vu"
  url "https://ghfast.top/https://github.com/vshulcz/deja-vu/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "893daa6c159e63d4d23d7b991f59a2e766cdc5bb157b6c6402faccb43d98fe6a"
  license "MIT"
  head "https://github.com/vshulcz/deja-vu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c778be974db8b4709e3c30daa6f552ebab71d5585b613ffcffce2a459502455d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c778be974db8b4709e3c30daa6f552ebab71d5585b613ffcffce2a459502455d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c778be974db8b4709e3c30daa6f552ebab71d5585b613ffcffce2a459502455d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1d797fb5e6efbb32fdbdfb1212618726f7eaf98cff6ec599455fea50f3b3b0e3"
    sha256 cellar: :any,                 x86_64_linux:      "73a29fc93ea75aea5176f719d25a1ea71982b9b7c833291602f0b713d8dde1fc"
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