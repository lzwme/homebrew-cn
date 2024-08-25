class PhpCodeSniffer < Formula
  desc "Check coding standards in PHP, JavaScript and CSS"
  homepage "https:github.comPHPCSStandardsPHP_CodeSniffer"
  url "https:github.comPHPCSStandardsPHP_CodeSnifferreleasesdownload3.10.2phpcs.phar"
  sha256 "5f580b08328af20a4138a6dcefdbb4c3307e133d9dfbabdf925c08c7d87f18de"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "195960ef111bf7ec5ef4b25b05c544d0690f05b259f31e952f5b82d7c73aa9fb"
  end

  depends_on "php"

  resource "phpcbf.phar" do
    url "https:github.comPHPCSStandardsPHP_CodeSnifferreleasesdownload3.10.2phpcbf.phar"
    sha256 "7b4b1316ce388600c2a052b41b9badd2d906827f0a08a08873ca5d1063dd1038"
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
    system bin"phpcs", "test.php"
  end
end