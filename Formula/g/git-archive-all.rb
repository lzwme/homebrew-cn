class GitArchiveAll < Formula
  include Language::Python::Shebang

  desc "Archive a project and its submodules"
  homepage "https:github.comKentzogit-archive-all"
  url "https:github.comKentzogit-archive-allarchiverefstags1.23.1.tar.gz"
  sha256 "0c440d15be18e336672549231510fa3c66d0cb95069a5e4800fdd876ab6814df"
  license "MIT"
  head "https:github.comKentzogit-archive-all.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, all: "b7048f7dce0b1d955d62f648271e3cf9b2e3ba3f32361468ed2809b6fda9d5b4"
  end

  depends_on "python@3.12"

  def install
    rewrite_shebang detected_python_shebang, "git_archive_all.py"

    system "make", "prefix=#{prefix}", "install"
  end

  test do
    (testpath".gitconfig").write <<~EOS
      [user]
        name = Real Person
        email = notacat@hotmail.cat
    EOS
    system "git", "init"
    touch "homebrew"
    system "git", "add", "homebrew"
    system "git", "commit", "--message", "brewing"

    assert_equal "#{testpath.realpath}homebrew => archivehomebrew",
                 shell_output("#{bin}git-archive-all --dry-run .archive").chomp
  end
end