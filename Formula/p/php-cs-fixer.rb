class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https:cs.symfony.com"
  # Bump to php 8.4 on the next release, if possible.
  url "https:github.comPHP-CS-FixerPHP-CS-Fixerreleasesdownloadv3.71.0php-cs-fixer.phar"
  sha256 "c6f8a9beff2b563d653163636a7ec7956f17a456e9755323d5c2e0e547e6e148"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3d22fcb9028eece4a4aaaf00364806449154a7231251a8fa9269366c99162cdd"
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