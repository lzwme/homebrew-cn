class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https:cs.symfony.com"
  # Bump to php 8.4 on the next release, if possible.
  url "https:github.comPHP-CS-FixerPHP-CS-Fixerreleasesdownloadv3.66.1php-cs-fixer.phar"
  sha256 "821c03f76bebb7a7e0764f141fc64b1cca796631b0bb007c43f6e4b303f7158c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7b1d1a70193e494e3e78fe3501d9579f69056192a31ebabbc71ebc6430f99c80"
  end

  depends_on "php@8.3"

  def install
    libexec.install "php-cs-fixer.phar"

    (bin"php-cs-fixer").write <<~PHP
      #!#{Formula["php@8.3"].opt_bin}php
      <?php require '#{libexec}php-cs-fixer.phar';
    PHP
  end

  test do
    (testpath"test.php").write <<~PHP
      <?php $this->foo(   'homebrew rox'   );
    PHP
    (testpath"correct_test.php").write <<~PHP
      <?php

      $this->foo('homebrew rox');
    PHP

    system bin"php-cs-fixer", "fix", "test.php"
    assert compare_file("test.php", "correct_test.php")
  end
end