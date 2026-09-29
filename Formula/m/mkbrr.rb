class Mkbrr < Formula
  desc "Is a tool to create, modify and inspect torrent files. Fast"
  homepage "https://mkbrr.com/introduction"
  url "https://ghfast.top/https://github.com/autobrr/mkbrr/archive/refs/tags/v1.26.0.tar.gz"
  sha256 "7a66b1d397a57ed34a18939e40e400e19998be956fd7923a56ab9b59ced8ffdb"
  license "GPL-2.0-or-later"
  head "https://github.com/autobrr/mkbrr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b79ed3431926305f8012e248e9137c082ff718e0669cd8d1886decfa92aed5a3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b79ed3431926305f8012e248e9137c082ff718e0669cd8d1886decfa92aed5a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b79ed3431926305f8012e248e9137c082ff718e0669cd8d1886decfa92aed5a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "806e890eb625e378d4614da9f67fdc1d431c95cee49e0c9898a65038234860a2"
    sha256 cellar: :any,                 x86_64_linux:      "8c415e6499befd7b3be962fd94e498b4e0879fa997bc69af709df3a2016c2226"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mkbrr version")

    (testpath/"hello.txt").write "Hello, World!"
    system bin/"mkbrr", "create", (testpath/"hello.txt"), "-o", (testpath/"hello.torrent")

    assert_path_exists testpath/"hello.torrent", "Failed to create torrent file"
  end
end