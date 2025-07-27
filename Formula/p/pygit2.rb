class Pygit2 < Formula
  desc "Bindings to the libgit2 shared library"
  homepage "https://github.com/libgit2/pygit2"
  url "https://files.pythonhosted.org/packages/ae/63/33e406a2c9aa631795fadf2ca5d680f384c22ad8e60d61c2e81417fe2f6f/pygit2-1.18.1.tar.gz"
  sha256 "84e06fc3708b8d3beeefcec637f61d87deb38272e7487ea1c529174184fff6c4"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }
  head "https://github.com/libgit2/pygit2.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3f3e7971dac70370d0371fd1347f59f8e394f77dc172f00a2b2ed72d8f03bab2"
    sha256 cellar: :any,                 arm64_sonoma:  "555e72ccdf93a76b8901fd3deed0e3534c231e119cc3b1cf447d8e87f3b7929b"
    sha256 cellar: :any,                 arm64_ventura: "68ddde683b19c03928a3ab9c98f4872379e617c1ad3bef6c7533df051431894f"
    sha256 cellar: :any,                 sonoma:        "4219e0f1b4f4615ed38a736cb6c4c096fc7c15f5ec505a6b5b96b687aa7ed32d"
    sha256 cellar: :any,                 ventura:       "4584b49b95a86df3c13441e3cad45a523b3cae34089afe10684627f57f3fd977"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29b6ef635ad2f2e2da77e91380d02ea23a837e94209c0fc27d1c79f5a6eb9cef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "499c0528f729da6b8976076a42182fe2a43988345de862f78e6640256beecf74"
  end

  depends_on "python@3.12" => [:build, :test]
  depends_on "python@3.13" => [:build, :test]
  depends_on "cffi"
  depends_on "libgit2"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python3|
      system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
    end
  end

  test do
    assert_empty resources, "This formula should not have any resources!"

    pythons.each do |python3|
      pyversion = Language::Python.major_minor_version(python3).to_s

      (testpath/pyversion/"hello.txt").write "Hello, pygit2."
      mkdir pyversion do
        system python3, "-c", <<~PYTHON
          import pygit2
          repo = pygit2.init_repository('#{testpath/pyversion}', False) # git init

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