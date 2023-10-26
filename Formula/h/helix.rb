class Helix < Formula
  desc "Post-modern modal text editor"
  homepage "https://helix-editor.com"
  url "https://ghproxy.com/https://github.com/helix-editor/helix/releases/download/23.10/helix-23.10-source.tar.xz"
  sha256 "4e7bcac200b1a15bc9f196bdfd161e4e448dc670359349ae14c18ccc512153e8"
  license "MPL-2.0"
  head "https://github.com/helix-editor/helix.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "79e8d2d32a3c09461fc136013a103ce171aaf2921acbcf3345458701b1deebcb"
    sha256 cellar: :any,                 arm64_ventura:  "4bec584df52681497f2688eb030f86d496cad35bbea288a856515ce714d9cab4"
    sha256 cellar: :any,                 arm64_monterey: "ec2c5741cb351b122b3cb19b035f659e571fb1d5f92eb4b8fed0de9c92face21"
    sha256 cellar: :any,                 sonoma:         "690626087dc09b6dba29b672c4d3c25f14b5c3909d86011577e533aa3d042b76"
    sha256 cellar: :any,                 ventura:        "4f09069b920b2c508dd56805d8078842a187fa72d2bc44eb789281a0a76b6b2a"
    sha256 cellar: :any,                 monterey:       "cb30ba51441b3430845b027bbc8df206aa0a0058d128ae06c5fbe52e06340ab8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13c651e189f210a3e6be381b6094daed308facebf228a60fa8abfb582cb184fb"
  end

  depends_on "rust" => :build

  fails_with gcc: "5" # For C++17

  def install
    system "cargo", "install", "-vv", *std_cargo_args(root: libexec, path: "helix-term")
    rm_r "runtime/grammars/sources/"
    libexec.install "runtime"

    (bin/"hx").write_env_script(libexec/"bin/hx", HELIX_RUNTIME: libexec/"runtime")

    bash_completion.install "contrib/completion/hx.bash" => "hx"
    fish_completion.install "contrib/completion/hx.fish"
    zsh_completion.install "contrib/completion/hx.zsh" => "_hx"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hx -V")
    assert_match "✓", shell_output("#{bin}/hx --health")
  end
end