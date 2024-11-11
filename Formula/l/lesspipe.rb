class Lesspipe < Formula
  desc "Input filter for the pager less"
  homepage "https:www-zeuthen.desy.de~friebelunixlesspipe.html"
  url "https:github.comwofr06lesspipearchiverefstagsv2.16.tar.gz"
  sha256 "18687fb0f416e2ec91a387b3159f84deba97d21d41ec89e72e7d5a1bf8ff9c01"
  license all_of: [
    "GPL-2.0-only",
    "GPL-2.0-or-later", # sxw2txt
    "MIT", # code2color
    any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"], # vimcolor
  ]

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3adbca0c592cc9ce801f4ccaa649d29e2f3ccb0c6011e7a5c653222e5767600d"
  end

  uses_from_macos "perl"

  def install
    system ".configure", "--all-completions", "--prefix=#{prefix}"
    man1.mkpath
    system "make", "install"
  end

  def caveats
    <<~EOS
      add the following to your shell profile e.g. ~.profile or ~.zshrc:
        export LESSOPEN="|#{HOMEBREW_PREFIX}binlesspipe.sh %s"
    EOS
  end

  test do
    touch "file1.txt"
    touch "file2.txt"
    system "tar", "-cvzf", "homebrew.tar.gz", "file1.txt", "file2.txt"

    assert_predicate testpath"homebrew.tar.gz", :exist?
    assert_match "file2.txt", pipe_output(bin"archive_color", shell_output("tar -tvzf homebrew.tar.gz"))
  end
end