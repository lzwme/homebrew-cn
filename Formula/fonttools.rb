class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/e5/55/86c43d626bbe12fb384e61152ded4f76a280d30a022968c471f850cdb0d5/fonttools-4.41.1.tar.gz"
  sha256 "e16a9449f21a93909c5be2f5ed5246420f2316e94195dbfccb5238aaa38f9751"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "413a977a85604ab05490211ecbe2000e27bf0afb6cfffa9860c4d1fadb5b7541"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15145fee081bfae216e6a0487821abf15bcc531a97a9cf47b4b5e0137f087706"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c6298830a7650f8614ac2fccde31894e0505d27a4366781f36d873fd69ed6864"
    sha256 cellar: :any_skip_relocation, ventura:        "1c64b514f6a89d03ebab166cbac6f49b04ac1b1debc45ecd91963fd2c9d259e2"
    sha256 cellar: :any_skip_relocation, monterey:       "56594396da2d57b9f5747f811724737231ab155bb1b3fbfbb2b8db1b86415307"
    sha256 cellar: :any_skip_relocation, big_sur:        "b69cb3763f34a0e81c792e9157c2ebcfbab076b0f689841854048d2713c17c03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba35761b3cb10cdfdf8ae304c0cc641f65c2750b676dd489893257456a02a41b"
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