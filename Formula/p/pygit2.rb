class Pygit2 < Formula
  desc "Bindings to the libgit2 shared library"
  homepage "https:github.comlibgit2pygit2"
  url "https:files.pythonhosted.orgpackages5377d33e2c619478d0daea4a50f9ffdd588db2ca55817c7e9a6c796fca3b80efpygit2-1.15.1.tar.gz"
  sha256 "e1fe8b85053d9713043c81eccc74132f9e5b603f209e80733d7955eafd22eb9d"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }
  head "https:github.comlibgit2pygit2.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "ee652799500f2047ba9148139f6429aaceb72294f860870d2d210cd109c1c960"
    sha256 cellar: :any,                 arm64_sonoma:   "c40189ab0e23eb85eabcf943b96af06d1755fb8010dc0e778bdf469ececc9127"
    sha256 cellar: :any,                 arm64_ventura:  "284f0a71c7e9943e1bd17e75fd3f51813cb3b485ead845dcc7a9c0d762823c96"
    sha256 cellar: :any,                 arm64_monterey: "287473b85ae42e77e229752cba29156be6138ae9f04781c7ee64bd8feab711e8"
    sha256 cellar: :any,                 sonoma:         "a09f033d21cb1491f78293f404599b6b89c322d0076b38da75dc2bba54552fb0"
    sha256 cellar: :any,                 ventura:        "2c36769afae51b497cb0e6a286c427f253b539328b3ec44c02c71542995ffa60"
    sha256 cellar: :any,                 monterey:       "87aa41266403f72dbe453928ef2e6b2742e90f50f0b697c16ab59fc827661770"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0470b2b8f8d41c65e39de0b01187c88112415d057cd52f8b881f9b97819c2359"
  end

  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
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