class Pygit2 < Formula
  desc "Bindings to the libgit2 shared library"
  homepage "https://github.com/libgit2/pygit2"
  url "https://files.pythonhosted.org/packages/82/08/77f77ec32b6d1363082be00c572f970d2a6200abf42df6d6ca86b8cd30e3/pygit2-1.13.0.tar.gz"
  sha256 "6dde37436fab14264ad3d6cbc5aae3fd555eb9a9680a7bfdd6e564cd77b5e2b8"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }
  head "https://github.com/libgit2/pygit2.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a3eae20f94d620f70149d714c4fe6da24e2254421b5f59e2a6ea95bba5c644a3"
    sha256 cellar: :any,                 arm64_monterey: "cef5e6c079eecc984635ea06707e21ca44138ab84bf69270a97a873257e21373"
    sha256 cellar: :any,                 arm64_big_sur:  "bf7528a34899aa2879f00c27a6336f349ca53c70f3e01f73dfd29e93656e0db1"
    sha256 cellar: :any,                 ventura:        "13739d096e062f7957bd70871fa3a068eb798f3f640da9419d01dff010d62b75"
    sha256 cellar: :any,                 monterey:       "1ba3220a5bb0ceec4c89058903f79d63c91c255f33d2e33552f8772e1c53dc12"
    sha256 cellar: :any,                 big_sur:        "d9ef36283df06645e64a19b818bacf3feeb6615407dd2c23d10662dd1bfce918"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "247a53da87692c871172d149434e4ef6b2cbd4bf126b702be93fdd20d904e2bd"
  end

  depends_on "cffi"
  depends_on "libgit2"
  depends_on "python@3.11"

  def python3
    "python3.11"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    assert_empty resources, "This formula should not have any resources!"
    (testpath/"hello.txt").write "Hello, pygit2."
    system python3, "-c", <<~PYTHON
      import pygit2
      repo = pygit2.init_repository('#{testpath}', False) # git init

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