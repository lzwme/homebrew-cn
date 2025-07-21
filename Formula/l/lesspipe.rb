class Lesspipe < Formula
  desc "Input filter for the pager less"
  homepage "https://www-zeuthen.desy.de/~friebel/unix/lesspipe.html"
  url "https://ghfast.top/https://github.com/wofr06/lesspipe/archive/refs/tags/v2.19.tar.gz"
  sha256 "32a56f2db7a9b45daf10cec6445afc8b600a6e88793b9d0cee6abe6b30ad1d47"
  license all_of: [
    "GPL-2.0-only",
    "GPL-2.0-or-later", # sxw2txt
    "MIT", # code2color
    any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"], # vimcolor
  ]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba151d7b9a0525b3782c1b06315166e45d7b60acb95459aff6731705e2b23b46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba151d7b9a0525b3782c1b06315166e45d7b60acb95459aff6731705e2b23b46"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ba151d7b9a0525b3782c1b06315166e45d7b60acb95459aff6731705e2b23b46"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba151d7b9a0525b3782c1b06315166e45d7b60acb95459aff6731705e2b23b46"
    sha256 cellar: :any_skip_relocation, ventura:       "ba151d7b9a0525b3782c1b06315166e45d7b60acb95459aff6731705e2b23b46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed1c9414decbfbdb557090c3a85590bbf60ed504c2fb6e4665c4e9af7d82d408"
  end

  uses_from_macos "perl"

  on_macos do
    depends_on "bash"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    man1.mkpath
    system "make", "install"
  end

  def caveats
    <<~EOS
      add the following to your shell profile e.g. ~/.profile or ~/.zshrc:
        export LESSOPEN="|#{HOMEBREW_PREFIX}/bin/lesspipe.sh %s"
    EOS
  end

  test do
    touch "file1.txt"
    touch "file2.txt"
    system "tar", "-cvzf", "homebrew.tar.gz", "file1.txt", "file2.txt"

    assert_path_exists testpath/"homebrew.tar.gz"
    assert_match "file2.txt", pipe_output(bin/"archive_color", shell_output("tar -tvzf homebrew.tar.gz"))
  end
end