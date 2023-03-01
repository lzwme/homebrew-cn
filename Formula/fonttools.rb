class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/55/5c/a4a25cf6db42d113d8f626901bb156b2f7cf7c7564a6bbc7b5cd6f7cb484/fonttools-4.38.0.zip"
  sha256 "2bb244009f9bf3fa100fc3ead6aeb99febe5985fa20afbfbaa2f8946c2fbdaf1"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de92e12d02a48b7aaf9f7ba4e99182caa3a3e9b3eb664fc937203d664698c2c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4addd737cb9cfb664f079c90bab3d6cb6392e3ab74787eafcec5175ae25641ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47c723506dc29274f10f821babd7ba9233a1ffed1245e1ee2ddeae790463d390"
    sha256 cellar: :any_skip_relocation, ventura:        "8407c66d03fb3d29500f7f72e0dc164878dcb5cd523e76ab633f6ccb688d7c9d"
    sha256 cellar: :any_skip_relocation, monterey:       "e2dfdf5b94e3faa1a837568868880897fb4b30e7416bebeedcdf2e068b099063"
    sha256 cellar: :any_skip_relocation, big_sur:        "b193010fed641f6e000e0c0192989308ed8fa7cc6178d6803fc79a454f5d1fb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a13fba679b7d8306c1de77bb859eb6eabb6ca4075f31df4f465fd80c78320b96"
  end

  depends_on "python@3.11"

  resource "Brotli" do
    url "https://files.pythonhosted.org/packages/2a/18/70c32fe9357f3eea18598b23aa9ed29b1711c3001835f7cf99a9818985d0/Brotli-1.0.9.zip"
    sha256 "4d1b810aa0ed773f81dceda2cc7b403d01057458730e309856356d4ef4188438"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    if OS.mac?
      cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath
      system bin/"ttx", "ZapfDingbats.ttf"
      system bin/"fonttools", "ttLib.woff2", "compress", "ZapfDingbats.ttf"
    else
      assert_match "usage", shell_output("#{bin}/ttx -h")
    end
  end
end