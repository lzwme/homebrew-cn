class Pygit2 < Formula
  desc "Bindings to the libgit2 shared library"
  homepage "https:github.comlibgit2pygit2"
  url "https:files.pythonhosted.orgpackages7b3c697dbc6b7b27f599ea96fbe0cd59bc4bed05652372a550d59990ab460096pygit2-1.14.0.tar.gz"
  sha256 "f529ed9660edbf9b625ccae7e51098ef73662e61496609009772d4627a826aa8"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }
  head "https:github.comlibgit2pygit2.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "34e811af2a5abf09eb36d044ef57f12d3f481fcdf0b9a69bf879c380c09e3bf1"
    sha256 cellar: :any,                 arm64_ventura:  "7bd8b0142c9ffdc30f3b94a149f5b2d3e8aea9d3bf5e9a5ffcc77923aac04401"
    sha256 cellar: :any,                 arm64_monterey: "91503a3d3dacbf0bba19ed1d4975cfb948955202b10f663ee47541c6413cc0db"
    sha256 cellar: :any,                 sonoma:         "670847f561bc2ec88a8504b37f05f6b54a859c8c8827dfa968167fc9aeb7d832"
    sha256 cellar: :any,                 ventura:        "80306ce71336d98155f7e392dde3adb81b0de78d96a4ab2737a959677d90dcef"
    sha256 cellar: :any,                 monterey:       "a63afa242c61c0659473cc2fc2ba00a488cfeee41ce525d67733f18d2977d3ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25f0513381d2267e4994fdb4ba91c4a3bf6574ec4857d38d707af0c22cced20c"
  end

  depends_on "python-setuptools" => :build
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