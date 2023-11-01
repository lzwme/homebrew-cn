class Pygit2 < Formula
  desc "Bindings to the libgit2 shared library"
  homepage "https://github.com/libgit2/pygit2"
  url "https://files.pythonhosted.org/packages/68/ac/268a23daedfaaaa54da8eceedb5ad1e425d9e6dd3cf5c5ffc170ff403d33/pygit2-1.13.2.tar.gz"
  sha256 "75c7eb86b47c70f6f1434bcf3b5eb41f4e8006a15cee6bef606651b97d23788c"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }
  head "https://github.com/libgit2/pygit2.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "baabe6f9387404b7a1ba7a0f84a60bd4760cecc721d3e22618a5baf9fe6f2a0d"
    sha256 cellar: :any,                 arm64_ventura:  "992f8b46f5b7ab7e90f385cbaf2a5089a0f17eba00c0dae2f346f2ad19bc9e96"
    sha256 cellar: :any,                 arm64_monterey: "9e33b7a40fe770dff16c8f0ae2599f5b873874de193787a088bbdc01de0c305b"
    sha256 cellar: :any,                 sonoma:         "3c4bd187dd1d61deaffd665d04e8c7d67dc90b1966d6fef4964d51146cea21ef"
    sha256 cellar: :any,                 ventura:        "c674f4bdbbb130a958ca124b909f8c196842511b788c0cae6fa5338a94993894"
    sha256 cellar: :any,                 monterey:       "fb4225d5b325dace77a79f51275e393679785a459af663d57b09f3bb1e192dd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e97cb6be79a6713fe3cb03f4a88546c163ec152b992b04a7f6170b99497499db"
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
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    assert_empty resources, "This formula should not have any resources!"

    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      pyversion = Language::Python.major_minor_version(python_exe)

      (testpath/"#{pyversion}/hello.txt").write "Hello, pygit2."
      mkdir pyversion do
        system python_exe, "-c", <<~PYTHON
          import pygit2
          repo = pygit2.init_repository('#{testpath}/#{pyversion}', False) # git init

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