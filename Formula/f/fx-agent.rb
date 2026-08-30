class FxAgent < Formula
  desc "Tiny, open, embeddable, native coding agent"
  homepage "https://fx.sh"
  url "https://ghfast.top/https://github.com/vercel-labs/fx/archive/refs/tags/v0.0.7.tar.gz"
  sha256 "bcbf3850b8e3ebcc1e8728104eec76242dd43399fe0c08b625887b2a6673427f"
  license "Apache-2.0"
  head "https://github.com/vercel-labs/fx.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "acf3e43674bfaf1c845dc92353be2d0a19f5f8cf569eb297eedb42f0611576d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9151377e505f6f81fe2eb58399f59ebe855f6164ef02602c03a001371655b15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30564afb6ec67ab25c067d8c74c14d0864ab56d5cabd9a1a49f0805a77c0848f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f595820f1a3b288a21f293bc817216601c0fa9d2d83f976cc482d1a84f2682aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02c9db4c424939dbedf52e639c17cc86bede24c354288a5d4add2d9f3c297d13"
  end

  depends_on "zig" => :build

  conflicts_with "fx", because: "both install an `fx` binary"

  def install
    system "zig", "build", *std_zig_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fx --version")

    output = shell_output("#{bin}/fx ask hello 2>&1", 1)
    assert_match "fx needs access to Vercel AI Gateway", output
  end
end