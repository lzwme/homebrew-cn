class PhpCodeSniffer < Formula
  desc "Check coding standards in PHP, JavaScript and CSS"
  homepage "https:github.comPHPCSStandardsPHP_CodeSniffer"
  url "https:github.comPHPCSStandardsPHP_CodeSnifferreleasesdownload3.11.1phpcs.phar"
  sha256 "cd9efa1a815148918be948ae1113f0a84dd484a1a39c2f5533929af83da9fdb1"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fc35d36e3e0da332833cf65e73d61f2e9c3a455c9353a66b3682c42622ec064b"
  end

  depends_on "php"

  resource "phpcbf.phar" do
    url "https:github.comPHPCSStandardsPHP_CodeSnifferreleasesdownload3.11.1phpcbf.phar"
    sha256 "d42c95da00f0bc9fed65201d69565e0ff508ff96579d04896981f55e7799446d"
  end

  def install
    odie "phpcbf.phar resource needs to be updated" if version != resource("phpcbf.phar").version

    bin.install "phpcs.phar" => "phpcs"
    resource("phpcbf.phar").stage { bin.install "phpcbf.phar" => "phpcbf" }
  end

  test do
    (testpath"test.php").write <<~PHP
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
    PHP

    assert_match "FOUND 13 ERRORS", shell_output("#{bin}phpcs --runtime-set ignore_errors_on_exit true test.php")
    assert_match "13 ERRORS WERE FIXED", shell_output("#{bin}phpcbf test.php", 1)
    system bin"phpcs", "test.php"
  end
end