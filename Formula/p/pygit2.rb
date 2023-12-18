class Pygit2 < Formula
  desc "Bindings to the libgit2 shared library"
  homepage "https:github.comlibgit2pygit2"
  url "https:files.pythonhosted.orgpackages0950f0795db653ceda94f4388d2b40598c188aa4990715909fabcf16b381b843pygit2-1.13.3.tar.gz"
  sha256 "0257c626011e4afb99bdb20875443f706f84201d4c92637f02215b98eac13ded"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }
  head "https:github.comlibgit2pygit2.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3e18c0e320d819c2be32109fa63371cde46e618c3bf4fd4466602e4527b53909"
    sha256 cellar: :any,                 arm64_ventura:  "2c60b4a14cd02a0d0f795178df8005a3d1beada99ff632545a51379ab3996385"
    sha256 cellar: :any,                 arm64_monterey: "7c68d1853fea9f4519821153c66164ae4021f4ba7a62c7f12ca2047c2f47502c"
    sha256 cellar: :any,                 sonoma:         "75903337466e82f6989858dd71a3e130da5365d28b0f2d69ad5da4d0e9d4927a"
    sha256 cellar: :any,                 ventura:        "bc022f022b1081b624ab8eabdeb82cc4701182c1975994ad09927c69294db911"
    sha256 cellar: :any,                 monterey:       "7461a77372d86acb2de61b58bc311b9b1033e21c8e95616b017a5a3a706ec058"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c98db8ca84bbee7209257f6af23aa886f11f0b6f942408baac029e7bc2bf5e23"
  end

  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "cffi"
  depends_on "libgit2"

  def pythons
    deps.select { |dep| dep.name.start_with?("python@") }
        .map(&:to_formula)
        .sort_by(&:version)
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec"binpython"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    assert_empty resources, "This formula should not have any resources!"

    pythons.each do |python|
      python_exe = python.opt_libexec"binpython"
      pyversion = Language::Python.major_minor_version(python_exe)

      (testpath"#{pyversion}hello.txt").write "Hello, pygit2."
      mkdir pyversion do
        system python_exe, "-c", <<~PYTHON
          import pygit2
          repo = pygit2.init_repository('#{testpath}#{pyversion}', False) # git init

          index = repo.index
          index.add('hello.txt')
          index.write() # git add

          ref = 'HEAD'
          author = pygit2.Signature('BrewTestBot', 'testbot@brew.sh')
          message = 'Initial commit'
          tree = index.write_tree()
          repo.create_commit(ref, author, author, message, tree, []) # git commit
        PYTHON

        system "git", "status"
        assert_match "hello.txt", shell_output("git ls-tree --name-only HEAD")
      end
    end
  end
end