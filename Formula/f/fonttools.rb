class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https:github.comfonttoolsfonttools"
  url "https:files.pythonhosted.orgpackages492e0b11e907b90665253dbad425479e874e38a9e81ced397a4e3312b9116935fonttools-4.55.6.tar.gz"
  sha256 "1beb4647a0df5ceaea48015656525eb8081af226fe96554089fd3b274d239ef0"
  license "MIT"
  head "https:github.comfonttoolsfonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1ad03ba56ce1079e64cccfaa46fa2e82a159be8717086294708b619c3fe2e92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e701c1f9f122b7ca34546220d5687fb22fe5600cf8a6e6fb57c0174bdcc3bf7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "257ada49b3c468a1e5bc97207dba3c6d89d77ee5b48de08a42e4f3f3f685019e"
    sha256 cellar: :any_skip_relocation, sonoma:        "4acf6dc00bc73eaad51f52d03f07f6d113e3cc3f028614c667890a26bd6084bc"
    sha256 cellar: :any_skip_relocation, ventura:       "fc0ec63a6a7a8f91d6ef1ef81490591b8ab652b07e7450eae7792ca208c76ce5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c71db355de9ac52c3165a042a551bd1e36611d1d9da1990a05ab33887e6e1580"
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
      assert_predicate testpath"ZapfDingbats.ttx", :exist?
      system bin"fonttools", "ttLib.woff2", "compress", "ZapfDingbats.ttf"
      assert_predicate testpath"ZapfDingbats.woff2", :exist?
    else
      assert_match "usage", shell_output("#{bin}ttx -h")
    end
  end
end