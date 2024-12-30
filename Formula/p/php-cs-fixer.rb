class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https:cs.symfony.com"
  # Bump to php 8.4 on the next release, if possible.
  url "https:github.comPHP-CS-FixerPHP-CS-Fixerreleasesdownloadv3.66.0php-cs-fixer.phar"
  sha256 "6db6e1ce24f106443b76dd43554d8f7a5d9068ef6c5f6e157a6a1786df5b8403"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0201e376f62a5d4c907eccd3c48f1a4d5d4040cbc3a3d2ff2bcc2aa37499df39"
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