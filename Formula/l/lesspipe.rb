class Lesspipe < Formula
  desc "Input filter for the pager less"
  homepage "https:www-zeuthen.desy.de~friebelunixlesspipe.html"
  url "https:github.comwofr06lesspipearchiverefstagsv2.14.tar.gz"
  sha256 "8da921f34b428f6347a37c36b167a523bbacada7dbdd952b708f554012867b67"
  license all_of: [
    "GPL-2.0-only",
    "GPL-2.0-or-later", # sxw2txt
    "MIT", # code2color
    any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"], # vimcolor
  ]

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "51b462f428e3845d2615cb9456f0f62fce329f655a92f20df86f7a9692ca2355"
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