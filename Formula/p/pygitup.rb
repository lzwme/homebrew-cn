class Pygitup < Formula
  include Language::Python::Virtualenv

  desc "Nicer 'git pull'"
  homepage "https://github.com/msiemens/PyGitUp"
  url "https://files.pythonhosted.org/packages/55/13/2dd3d4c9a021eb5fa6d8afbb29eb9e6eb57faa56cf10effe879c9626eed1/git_up-2.2.0.tar.gz"
  sha256 "1935f62162d0e3cc967cf9e6b446bd1c9e6e9902edb6a81396065095a5a0784e"
  license "MIT"
  revision 3

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d03c80d0962830058c66ea625f53a589373fd7864f69244d4a179afc061dad32"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb6b7f9a4e83d304c7a12055d1a509593fe7cfd83b6f94f59d2904d267738b16"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a2287df898153bd5aaf59333ea1c83d333b8ab8e4f85d075c34f0b900172bc14"
    sha256 cellar: :any_skip_relocation, ventura:        "8615f1fb55f61a241ca8b87cdee737999fa319e826c9bfed87694f96aad519cf"
    sha256 cellar: :any_skip_relocation, monterey:       "7c07f67314f7f0e9a784891f530b1ec5d665822fc6fec59421a3be2965c34a54"
    sha256 cellar: :any_skip_relocation, big_sur:        "6b1cbc27a02dec2724b82baaaaf334e2a03b803ab43e34f6f883b9a3137b5300"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbf081192080869035459b08c547940554d20f2e5cc298b7edcadf78042d83b4"
  end

  depends_on "python-typing-extensions"
  depends_on "python@3.11"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/4b/47/dc98f3d5d48aa815770e31490893b92c5f1cd6c6cf28dd3a8ae0efffac14/gitdb-4.0.10.tar.gz"
    sha256 "6eb990b69df4e15bad899ea868dc46572c3f75339735663b81de79b06f17eb9a"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/f6/7e/74206b2ac9f63a40cbfc7bfdf69cda4a3bde9d932129bee2352f6bdec555/GitPython-3.1.34.tar.gz"
    sha256 "85f7d365d1f6bf677ae51039c1ef67ca59091c7ebd5a3509aa399d4eda02d6dd"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/21/2d/39c6c57032f786f1965022563eec60623bb3e1409ade6ad834ff703724f3/smmap-5.0.0.tar.gz"
    sha256 "c840e62059cd3be204b0c9c9f74be2c09d5648eddd4580d9314c3ecde0b30936"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/b8/85/147a0529b4e80b6b9d021ca8db3a820fcac53ec7374b87073d004aaf444c/termcolor-2.3.0.tar.gz"
    sha256 "b5b08f68937f138fe92f6c089b99f1e2da0ae56c52b78bf7075fd95420fd9a5a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    system "git", "clone", "https://github.com/Homebrew/install.git"
    cd "install" do
      assert_match "Fetching origin", shell_output("#{bin}/git-up")
    end
  end
end