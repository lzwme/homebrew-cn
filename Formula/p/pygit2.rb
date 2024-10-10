class Pygit2 < Formula
  desc "Bindings to the libgit2 shared library"
  homepage "https:github.comlibgit2pygit2"
  url "https:files.pythonhosted.orgpackages5377d33e2c619478d0daea4a50f9ffdd588db2ca55817c7e9a6c796fca3b80efpygit2-1.15.1.tar.gz"
  sha256 "e1fe8b85053d9713043c81eccc74132f9e5b603f209e80733d7955eafd22eb9d"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }
  revision 1
  head "https:github.comlibgit2pygit2.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3af08338fa5ba19e98695c35b161a5d1bc303ba10cd597080bb88b9d5583c0eb"
    sha256 cellar: :any,                 arm64_sonoma:  "67d67d9fa2bc7be9a5f6c5ad100802c20fc71ed5b1caf65eefbadc32ecf97eba"
    sha256 cellar: :any,                 arm64_ventura: "b82f3db0d926461e7e83916a927b7da690e5f7d804bf3cb86b836350e1d3009e"
    sha256 cellar: :any,                 sonoma:        "4988a98e6c01150046eb183b661e3866b7a5d2bc5daf45d9a2d5222838a2918d"
    sha256 cellar: :any,                 ventura:       "ad03b6d4edd0172bee62bc5394194b634ff1db63c1ba6e2e0b92df1dbaefee53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ec4345179520c99772b5578d896862ee721f03ed35658ddeff75b615371f132"
  end

  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "python@3.13" => [:build, :test]
  depends_on "cffi"
  depends_on "libgit2"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec"binpython" }
  end

  def install
    pythons.each do |python3|
      system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
    end
  end

  test do
    assert_empty resources, "This formula should not have any resources!"

    pythons.each do |python3|
      pyversion = Language::Python.major_minor_version(python3)

      (testpath"#{pyversion}hello.txt").write "Hello, pygit2."
      mkdir pyversion do
        system python3, "-c", <<~PYTHON
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