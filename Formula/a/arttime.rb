class Arttime < Formula
  desc "Clock, timer, time manager and ASCII+ text-art viewer for the terminal"
  homepage "https:github.compoetamanarttime"
  url "https:github.compoetamanarttimearchiverefstagsv2.1.3.tar.gz"
  sha256 "eb5ffaea82e39e47f0017b690ba8337a43a36437a5b2cf86f0fb0e795f01d4d4"
  license "GPL-3.0-only"
  head "https:github.compoetamanarttime.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "27707e1bb7b754c18ea9c2bdec16b6f726e287d4bf7621fdeae2ff3c22d54450"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "27707e1bb7b754c18ea9c2bdec16b6f726e287d4bf7621fdeae2ff3c22d54450"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27707e1bb7b754c18ea9c2bdec16b6f726e287d4bf7621fdeae2ff3c22d54450"
    sha256 cellar: :any_skip_relocation, sonoma:         "4dcb8459212b1327444cef269034c8b12a2721d8cfd4b7b172a2e29c892f0255"
    sha256 cellar: :any_skip_relocation, ventura:        "4dcb8459212b1327444cef269034c8b12a2721d8cfd4b7b172a2e29c892f0255"
    sha256 cellar: :any_skip_relocation, monterey:       "4dcb8459212b1327444cef269034c8b12a2721d8cfd4b7b172a2e29c892f0255"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27707e1bb7b754c18ea9c2bdec16b6f726e287d4bf7621fdeae2ff3c22d54450"
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
    system ".install.sh", "--noupdaterc", "--prefix", prefix, "--zcompdir", zsh_completion
  end

  test do
    # arttime is a GUI application
    system bin"arttime", "--version"
  end
end