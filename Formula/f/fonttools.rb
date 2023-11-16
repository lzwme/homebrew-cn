class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/c4/9f/9c3c66017e2be1aa04d9ae54936c932b1e3ad09f70987a9b8a9a2c71ccaa/fonttools-4.44.3.tar.gz"
  sha256 "f77b6c0add23a3f1ec8eda40015bcb8e92796f7d06a074de102a31c7d007c05b"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b3d4d070cc90ff171da579e67511486e2a3e747c0a0296b1830557f3b10cd374"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02310436fbc0a5bd311a7caebf21434e9fec016343e5e97ff2ce7d7a79bbdb95"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07bddfadedc3fa41e5c57985194c0b6bb46353ca057c0677fc8bc9061c9af45c"
    sha256 cellar: :any_skip_relocation, sonoma:         "b310bcef63ba28d9b3fb4ccfa2b6c87f0f8336becebff2a638fe613d119f5dfc"
    sha256 cellar: :any_skip_relocation, ventura:        "2b44ef1f8475d13a388d1e79daeba390bee4006c207222c3c91447a93f7ffacb"
    sha256 cellar: :any_skip_relocation, monterey:       "e8d53d2a521455b4eb92d5fee5c156ea6185044f9d923055e09a9c374fdae1c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f5882ed5c35176b03b9de36e08e9bf30a634a7a79d6cfc4d7c31062538a2e8f"
  end

  depends_on "python@3.12"

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/2f/c2/f9e977608bdf958650638c3f1e28f85a1b075f075ebbe77db8555463787b/Brotli-1.1.0.tar.gz"
    sha256 "81de08ac11bcb85841e440c13611c00b67d3bf82698314928d0b676362546724"
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