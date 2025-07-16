class Helix < Formula
  desc "Post-modern modal text editor"
  homepage "https://helix-editor.com"
  url "https://ghfast.top/https://github.com/helix-editor/helix/releases/download/25.07/helix-25.07-source.tar.xz"
  sha256 "22f037e8c4bbef67b7aa6db3448063f87004159fde6a9ce684082963bfeba4e5"
  license "MPL-2.0"
  head "https://github.com/helix-editor/helix.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "61fb6d5f97dcf0d9e2939058f1046f19c1d3ed63f2808ff0ad5034b36d658ed9"
    sha256 cellar: :any,                 arm64_sonoma:  "049aa43b8112ede3ac51edb222f20965ca13d4ddf505882c58c7a6da2fd528ce"
    sha256 cellar: :any,                 arm64_ventura: "29381672d5fb4886712ca7b0e67fb578db76202408d8c148bcf265f8f54fb94a"
    sha256 cellar: :any,                 sonoma:        "2329187f2fcc76b4b853315653ea0f4f88b23e7f01994812e632d959860fbd37"
    sha256 cellar: :any,                 ventura:       "dbea980364bf70e270cdb4e6e6e895773d175d646eb0260053777004181892ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee6b65330ef2e64f344e8ec5d0231f65da1e21b3f45062c6d628eef687769111"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fd183435744b4e6083e2ac5567a42c4d4fbf43fdbc95ef8214cf7036b149c82"
  end

  depends_on "rust" => :build

  conflicts_with "evil-helix", because: "both install `hx` binaries"
  conflicts_with "hex", because: "both install `hx` binaries"

  def install
    ENV["HELIX_DEFAULT_RUNTIME"] = libexec/"runtime"
    system "cargo", "install", "-vv", *std_cargo_args(path: "helix-term")
    rm_r "runtime/grammars/sources/"
    libexec.install "runtime"

    bash_completion.install "contrib/completion/hx.bash" => "hx"
    fish_completion.install "contrib/completion/hx.fish"
    zsh_completion.install "contrib/completion/hx.zsh" => "_hx"
  end

  test do
    assert_match "post-modern text editor", shell_output("#{bin}/hx --help")
    assert_match "✓", shell_output("#{bin}/hx --health")
  end
end