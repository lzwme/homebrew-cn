class Ggc < Formula
  desc "Modern Git CLI"
  homepage "https://github.com/bmf-san/ggc"
  url "https://ghfast.top/https://github.com/bmf-san/ggc/archive/refs/tags/v8.7.5.tar.gz"
  sha256 "af893a01471700e27d560d8320f8c72d13842954b9ba0eba55b14dae300a3381"
  license "MIT"
  head "https://github.com/bmf-san/ggc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1a6e66665dcc5ef682ea63a8588552d61c68c8151b7c228db0db5d86ec25951e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1a6e66665dcc5ef682ea63a8588552d61c68c8151b7c228db0db5d86ec25951e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1a6e66665dcc5ef682ea63a8588552d61c68c8151b7c228db0db5d86ec25951e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bcae00d0c32e85c2e2e9c530b93aa80a6076f921daa2260888664d5bc2cf1367"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "8453938134de041601fea1b8a1b6420bcc7a4e702ed1debf2b22b7b597dc3b7b"
  end

  depends_on "go" => :build

  uses_from_macos "vim"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ggc version")
    assert_equal "main", shell_output("#{bin}/ggc config get default.branch").chomp
  end
end