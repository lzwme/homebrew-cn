class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https:github.comfonttoolsfonttools"
  url "https:files.pythonhosted.orgpackages9acf4d037663e2a1fe30fddb655d755d76e18624be44ad467c07412c2319ab97fonttools-4.58.0.tar.gz"
  sha256 "27423d0606a2c7b336913254bf0b1193ebd471d5f725d665e875c5e88a011a43"
  license "MIT"
  head "https:github.comfonttoolsfonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76a1a9680f6bcfab95e385afae9ac6162142826bef7ffc989d005bbf944ad7df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0abbdcc42053b7c7d8b0c651912ec59666e1a2e6b6a7a6c3ad6166360681f46"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eba7206836e65baae244be6df16b3f57c5a1741d57e08a8df6187d80d64f5e09"
    sha256 cellar: :any_skip_relocation, sonoma:        "871424abb8cc936572afdd002060e594a35266a1dca75163cb0029117da7d58d"
    sha256 cellar: :any_skip_relocation, ventura:       "0f8f9eed4f7bb5a960ffeaad9410f4502d005089818c65bf0579726a95070600"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2abf1e12789897aaed9e64ab22d7305af5053f25f62650a2e52d3a0a31740a21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a136b349acac3ac28b172d5bf3185247380e30a67ff249df2361241c42d1f364"
  end

  depends_on "python@3.13"

  resource "brotli" do
    url "https:files.pythonhosted.orgpackages2fc2f9e977608bdf958650638c3f1e28f85a1b075f075ebbe77db8555463787bBrotli-1.1.0.tar.gz"
    sha256 "81de08ac11bcb85841e440c13611c00b67d3bf82698314928d0b676362546724"
  end

  resource "zopfli" do
    url "https:files.pythonhosted.orgpackages5e7ca8f6696e694709e2abcbccd27d05ef761e9b6efae217e11d977471555b62zopfli-0.2.3.post1.tar.gz"
    sha256 "96484dc0f48be1c5d7ae9f38ed1ce41e3675fd506b27c11a6607f14b49101e99"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    if OS.mac?
      cp "SystemLibraryFontsZapfDingbats.ttf", testpath

      system bin"ttx", "ZapfDingbats.ttf"
      assert_path_exists testpath"ZapfDingbats.ttx"
      system bin"fonttools", "ttLib.woff2", "compress", "ZapfDingbats.ttf"
      assert_path_exists testpath"ZapfDingbats.woff2"
    else
      assert_match "usage", shell_output("#{bin}ttx -h")
    end
  end
end