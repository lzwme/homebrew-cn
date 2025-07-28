class Arttime < Formula
  desc "Clock, timer, time manager and ASCII+ text-art viewer for the terminal"
  homepage "https://github.com/poetaman/arttime"
  url "https://ghfast.top/https://github.com/poetaman/arttime/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "f1418522d36528b38ce604d1a9ec14ddf6284aa6a15d28a7eb5c01a872a6d436"
  license "GPL-3.0-only"
  head "https://github.com/poetaman/arttime.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f1c1e43694a6d11b3b352e7da96257c31d87b3e9519916f4771e89838fa16d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f1c1e43694a6d11b3b352e7da96257c31d87b3e9519916f4771e89838fa16d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0f1c1e43694a6d11b3b352e7da96257c31d87b3e9519916f4771e89838fa16d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "c02a8f8636056b9fe573246399be2a8763ae60277261f2b4dd1e8f087c33a68c"
    sha256 cellar: :any_skip_relocation, ventura:       "c02a8f8636056b9fe573246399be2a8763ae60277261f2b4dd1e8f087c33a68c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f1c1e43694a6d11b3b352e7da96257c31d87b3e9519916f4771e89838fa16d1"
  end

  depends_on "fzf"

  on_linux do
    depends_on "diffutils"
    depends_on "less"
    depends_on "libnotify"
    depends_on "vorbis-tools"
    depends_on "zsh"
  end

  def install
    ENV["TERM"]="xterm"
    system "./install.sh", "--noupdaterc", "--prefix", prefix, "--zcompdir", zsh_completion
  end

  test do
    # arttime is a GUI application
    system bin/"arttime", "--version"
  end
end