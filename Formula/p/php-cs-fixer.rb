class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https:cs.symfony.com"
  # Bump to php 8.4 on the next release, if possible.
  url "https:github.comPHP-CS-FixerPHP-CS-Fixerreleasesdownloadv3.65.0php-cs-fixer.phar"
  sha256 "e7f00398e696cf49dbb7e67ec219ad920b313084f7143919aba7b1c3afff0c8d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "66c9e35737fdc662087ff406ad62be6c6266668d55fa3a28ffa58d20d6ea0c32"
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