class PhpCodeSniffer < Formula
  desc "Check coding standards in PHP, JavaScript and CSS"
  homepage "https:github.comPHPCSStandardsPHP_CodeSniffer"
  url "https:github.comPHPCSStandardsPHP_CodeSnifferreleasesdownload3.10.0phpcs.phar"
  sha256 "72ee18958d6fcd8eb9790c30714e945be8a095f5b48856cce82e0eb769c5f3ff"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d2a0788487e78fcdd143003bcba72b4f6b3b519bb15df70322821431b4ab3c35"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e212bc24fcebc5620c6954747fdbbf5b2817bc316d77891911e8f7c9b9821fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "063c9e95791066cc86fc83d8bb35eb033171f31b08956479e78640ff060b58c5"
    sha256 cellar: :any_skip_relocation, sonoma:         "fd461ab85880d2ff90f1cf2c01dfdb9edf460ec5482b54f53afd64a393a45769"
    sha256 cellar: :any_skip_relocation, ventura:        "6cac86808a9a7a19ed0233639030c3dcfb6646d2dc8271ae6e19c1eb8dd1346d"
    sha256 cellar: :any_skip_relocation, monterey:       "757f64852da179ba03ababef74a497a9e6ba196c46c3f447f2687433ff281d71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a60cf66992e5586cb3af617adbfa7e01fc82b9ad89cc87a4a8f8b0e848ce92d"
  end

  depends_on "php"

  resource "phpcbf.phar" do
    url "https:github.comPHPCSStandardsPHP_CodeSnifferreleasesdownload3.10.0phpcbf.phar"
    sha256 "a5b054f444d5cc9f0b16c7c3429fcd744e4316475005b63c06f2efcca71dc79e"
  end

  def install
    odie "phpcbf.phar resource needs to be updated" if version != resource("phpcbf.phar").version

    bin.install "phpcs.phar" => "phpcs"
    resource("phpcbf.phar").stage { bin.install "phpcbf.phar" => "phpcbf" }
  end

  test do
    (testpath"test.php").write <<~EOS
      <?php
      **
      * PHP version 5
      *
      * @category  Homebrew
      * @package   Homebrew_Test
      * @author    Homebrew <do.not@email.me>
      * @license   BSD Licence
      * @link      https:brew.sh
      *
    EOS

    assert_match "FOUND 13 ERRORS", shell_output("#{bin}phpcs --runtime-set ignore_errors_on_exit true test.php")
    assert_match "13 ERRORS WERE FIXED", shell_output("#{bin}phpcbf test.php", 1)
    system "#{bin}phpcs", "test.php"
  end
end