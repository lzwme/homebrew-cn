class Trzsz < Formula
  include Language::Python::Virtualenv

  desc "Simple file transfer tools, similar to lrzsz (rz/sz), and compatible with tmux"
  homepage "https://trzsz.github.io"
  url "https://files.pythonhosted.org/packages/60/fb/fcaeef46e58afa2cf2fef5ce1ad9f4e083feb157b4e12b3687114d2a5ed7/trzsz-1.1.1.tar.gz"
  sha256 "f113783ca8533252813d355e9a200e78762cafd4197a841f6b5289112ebf5805"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "92e240ab29a8a38045df7f11c24781dfc001c566d7131d34165ca33d977e7b6c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f4883613c85069602bafbf57782788962c0c5b025543fafd7fbd5ca5da7c3b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b299420f609d20762fa4f06366a9fe2c30ff96dbfcbb607a4091bafeb0563f54"
    sha256 cellar: :any_skip_relocation, ventura:        "6c1bfaed118bc729b5328dffc5bb6e087a166f7d3016439ea967952a82ff5954"
    sha256 cellar: :any_skip_relocation, monterey:       "5d4a12f30d95e5931ef0520e2fce7097dadddfd0df0998d874d597124c4bd9f9"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ea70e3217f93d8783c33c1b70a43d82aedd703eb9fb6848cce44b40a8841733"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2290accbb6527d9e3c1c4603be61f58053cf36cb5bc53e9d5d8c28e421ff102"
  end

  depends_on "protobuf"
  depends_on "python@3.11"

  resource "iterm2" do
    url "https://files.pythonhosted.org/packages/4f/eb/47bb125fd3b32969f3bc8e0b8997bbe308484ac4d04331ae1e6199ae2c0f/iterm2-2.7.tar.gz"
    sha256 "f6f0bec46c32cecaf7be7fd82296ec4697d4bf2101f0c4aab24cc123991fa230"
  end

  resource "trzsz-iterm2" do
    url "https://files.pythonhosted.org/packages/77/5f/6b9f043c19458246886810a6af4d1f977328b2d158fa1e3825666c298498/trzsz-iterm2-1.1.1.tar.gz"
    sha256 "6bbcc011ed1936ee1ed01b33ac8f290ed90fdff2d9e0e8a6070cd61fc8e2b9bd"
  end

  resource "trzsz-libs" do
    url "https://files.pythonhosted.org/packages/01/4b/9f4ca38ba1cef8a4d44ac7115cea8eaf1e47dc88ddb10a72646682b8cc09/trzsz-libs-1.1.1.tar.gz"
    sha256 "8536733f42eb30bdede15ff49995d241447c8f64cda85d3a1a382b9267b79113"
  end

  resource "trzsz-svr" do
    url "https://files.pythonhosted.org/packages/bb/60/48cf879ebdc262769ccfd50c7954a533628c83faeae095be7dcc20f18769/trzsz-svr-1.1.1.tar.gz"
    sha256 "e02e8240b0b9de7c8c72557597954158a5591660a291b6f70a0f54e1dedcd273"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/85/dc/549a807a53c13fd4a8dac286f117a7a71260defea9ec0c05d6027f2ae273/websockets-10.4.tar.gz"
    sha256 "eef610b23933c54d5d921c92578ae5f89813438fded840c2e9809d378dc765d3"
  end

  def install
    virtualenv_install_with_resources
    bin.install_symlink libexec/"bin/trz"
    bin.install_symlink libexec/"bin/tsz"
    bin.install_symlink libexec/"bin/trzsz-iterm2"
  end

  test do
    assert_match "trz (trzsz) py #{version}", shell_output("#{bin}/trz -v")
    assert_match "tsz (trzsz) py #{version}", shell_output("#{bin}/tsz -v")
    assert_match "trzsz-iterm2 (trzsz) py #{version}", shell_output("#{bin}/trzsz-iterm2 -v")

    touch "tmpfile"
    assert_match "Not a directory", shell_output("#{bin}/trz tmpfile 2>&1")

    rm "tmpfile"
    assert_match "No such file", shell_output("#{bin}/tsz tmpfile 2>&1")

    assert_match "arguments are required", shell_output("#{bin}/trzsz-iterm2 2>&1", 2)
  end
end