class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/c8/3a/e3d6005356047aefb43e47b55b4f72de73deb55c78e787701ecd36c81f12/fonttools-4.41.0.tar.gz"
  sha256 "6faff25991dec48f8cac882055a09ae1a29fd15bc160bc3d663e789e994664c2"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "86e02a25c75c0ef971ca17d35db51eb8116107ec68abff9822f05d0ad1dc503b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28447d67d23bc433eddf9022b7632669f7cdcd28209d934dd00e59bba8211b1a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5abdae92908da27aa2847bdcca09fa193a7e1387122a034abbe740e9bb65b4c0"
    sha256 cellar: :any_skip_relocation, ventura:        "dbc67285325ad1044052bdd4d89e62f3987d0500cf9f9399a21bb9a8220911d7"
    sha256 cellar: :any_skip_relocation, monterey:       "5b14b1b1472aad4776b96f7a0a0828d00405c145b5ead1dd734b1a058c09fbdc"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c279bb940d99808b3c52deae35d7da993de8279c55e540a97fe71187592e2aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fe22c9ea261b3480d1520bf9013d37c197420cc07686a98fb762069e4439440"
  end

  depends_on "python@3.11"

  resource "brotli" do
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