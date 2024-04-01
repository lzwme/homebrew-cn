class PhpCodeSniffer < Formula
  desc "Check coding standards in PHP, JavaScript and CSS"
  homepage "https:github.comPHPCSStandardsPHP_CodeSniffer"
  url "https:github.comPHPCSStandardsPHP_CodeSnifferreleasesdownload3.9.1phpcs.phar"
  sha256 "665c8459a5e157e1b909ef6561ffedebfe54b42303288c0784755450bbefd232"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "997ed2a458bef8142db9103683477f39c29932d6cd0683bc9b355a6452903e66"
  end

  depends_on "php"

  resource "phpcbf.phar" do
    url "https:github.comPHPCSStandardsPHP_CodeSnifferreleasesdownload3.9.1phpcbf.phar"
    sha256 "040d1d519d49dd47174789ccf12ebbc49f1e109278c11f2a0b968dfd491e0675"
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