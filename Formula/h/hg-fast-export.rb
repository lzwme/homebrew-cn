class HgFastExport < Formula
  include Language::Python::Shebang

  desc "Fast Mercurial to Git converter"
  homepage "https:repo.or.czfast-export.git"
  url "https:github.comfrejfast-exportarchiverefstagsv231118.tar.gz"
  sha256 "2173c8cb2649c05affe6ef1137bc6a06913f06e285bcd710277478a04a3a937f"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "6a644292119def3bf821f4426f610d0c489caa77dc269a0d2160c642c3c22347"
  end

  depends_on "mercurial"
  depends_on "python@3.12"

  # Fix compatibility with Python 3.12 using open PR.
  # PR ref: https:github.comfrejfast-exportpull311
  patch do
    url "https:github.comfrejfast-exportcommita3d0562737e1e711659e03264e45cb47a5a2f46d.patch?full_index=1"
    sha256 "8d9d5a41939506110204ae00607061f85362467affd376387230e074bcae2667"
  end

  def install
    # The Python executable is tested from PATH
    # Prepend ours Python to the executable candidate list (python2 python python3)
    # See https:github.comHomebrewhomebrew-corepull90709#issuecomment-988548657
    %w[hg-fast-export.sh hg-reset.sh].each do |f|
      inreplace f, "for python_cmd in ",
                   "for python_cmd in '#{which("python3.12")}' "
    end

    libexec.install Dir["*"]

    %w[hg-fast-export.py hg-fast-export.sh hg-reset.py hg-reset.sh hg2git.py].each do |f|
      rewrite_shebang detected_python_shebang, libexecf
      bin.install_symlink libexecf
    end
  end

  test do
    mkdir testpath"hg-repo" do
      system "hg", "init"
      (testpath"hg-repotest.txt").write "Hello"
      system "hg", "add", "test.txt"
      system "hg", "commit", "-u", "test@test", "-m", "test"
    end

    mkdir testpath"git-repo" do
      system "git", "config", "--global", "init.defaultBranch", "master"
      system "git", "init"
      system "git", "config", "core.ignoreCase", "false"
      system bin"hg-fast-export.sh", "-r", "#{testpath}hg-repo"
      system "git", "checkout", "HEAD"
    end

    assert_predicate testpath"git-repotest.txt", :exist?
    assert_equal "Hello", (testpath"git-repotest.txt").read
  end
end