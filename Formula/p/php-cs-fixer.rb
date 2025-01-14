class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https:cs.symfony.com"
  # Bump to php 8.4 on the next release, if possible.
  url "https:github.comPHP-CS-FixerPHP-CS-Fixerreleasesdownloadv3.68.0php-cs-fixer.phar"
  sha256 "75ccdf17d43c8d924a3714e4ff5f8274a651683d41e62dac15a34b0fcc9efaa1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0dd49ce475969c4a1096199eef8ab6a7e04b7f2d22ef898431c02f660aebad63"
  end

  depends_on "php@8.3" # php 8.4 support milestone, https:github.comPHP-CS-FixerPHP-CS-Fixermilestone173

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