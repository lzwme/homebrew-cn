class ShallowBackup < Formula
  include Language::Python::Virtualenv

  desc "Git-integrated backup tool for macOS and Linux devs"
  homepage "https://github.com/alichtman/shallow-backup"
  url "https://files.pythonhosted.org/packages/eb/33/4b56af73e95125cd6d92972a3e55c82f3ac9386d3401dd198f886a99bb0e/shallow-backup-6.0.tar.gz"
  sha256 "8fa5b8052c9f9c4f4ef456cf2f0163ef0fffb5c3a96e506665bae7899b5cc72c"
  license "MIT"
  revision 2
  head "https://github.com/alichtman/shallow-backup.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24ed5a4ceca0b7a3a2d6fcdbc41d19e08635681e6400c6d969fe9ea37e585c36"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e84e6d997501d491512eef859ae2b6a4b06f007b128533159c80d721100b306d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "880076820e6642d109451c9a2cde41105114bbefca2b14bb39bcc00e4472b4b4"
    sha256 cellar: :any_skip_relocation, ventura:        "89ce02d2b1780a290530495cd59a0493940112a8607e14ba8b866e0d059c8746"
    sha256 cellar: :any_skip_relocation, monterey:       "10a59e1e30dca9f8cf7003301e7033d1279b55ab991779708afd8e8b4b44a2dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "e8fb89dadb528c0316ceb476c4c4cc0ccd63708871792a1b8922015f74f5514f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d5587ece68b9d0ad68f17851377ab59c96707fb8e6d74456220047c8e99a4b8"
  end

  depends_on "python@3.11"
  depends_on "six"

  resource "blessed" do
    url "https://files.pythonhosted.org/packages/25/ae/92e9968ad23205389ec6bd82e2d4fca3817f1cdef34e10aa8d529ef8b1d7/blessed-1.20.0.tar.gz"
    sha256 "2cdd67f8746e048f00df47a2880f4d6acbcdb399031b604e34ba8f71d5787680"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

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

  resource "inquirer" do
    url "https://files.pythonhosted.org/packages/1b/e3/e2998fad3add25dc7dad7decb8dcd92e71888d7e9514c647d0a461a7381c/inquirer-3.1.3.tar.gz"
    sha256 "aac309406f5b49d4b8ab7c6872117f43bf082a552dc256aa16bc95e16bb58bec"
  end

  resource "python-editor" do
    url "https://files.pythonhosted.org/packages/0a/85/78f4a216d28343a67b7397c99825cff336330893f00601443f7c7b2f2234/python-editor-1.0.4.tar.gz"
    sha256 "51fda6bcc5ddbbb7063b2af7509e43bd84bfc32a4ff71349ec7847713882327b"
  end

  resource "readchar" do
    url "https://files.pythonhosted.org/packages/a1/57/439aaa28659e66265518232bf4291ae5568aa01cd9e0e0f6f8fe3b300e9e/readchar-4.0.5.tar.gz"
    sha256 "08a456c2d7c1888cde3f4688b542621b676eb38cd6cfed7eb6cb2e2905ddc826"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/21/2d/39c6c57032f786f1965022563eec60623bb3e1409ade6ad834ff703724f3/smmap-5.0.0.tar.gz"
    sha256 "c840e62059cd3be204b0c9c9f74be2c09d5648eddd4580d9314c3ecde0b30936"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/5e/5f/1e4bd82a9cc1f17b2c2361a2d876d4c38973a997003ba5eb400e8a932b6c/wcwidth-0.2.6.tar.gz"
    sha256 "a5220780a404dbe3353789870978e472cfe477761f06ee55077256e509b156d0"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # Creates a config file and adds a test file to it
    # There is colour in stdout, hence there are ANSI escape codes
    assert_equal "\e[34m\e[1mCreating config file at: \e[22m#{pwd}/.config/shallow-backup.conf\e[0m\n" \
                 "\e[34m\e[1mAdded: \e[22m#{test_fixtures("test.svg")}\e[0m",
    shell_output("#{bin}/shallow-backup --add-dot #{test_fixtures("test.svg")}").strip

    # Checks if config file was created
    assert_predicate testpath/".config/shallow-backup.conf", :exist?

    # Checks if the test file is in the config
    assert_match "test.svg", shell_output("#{bin}/shallow-backup --show")
  end
end