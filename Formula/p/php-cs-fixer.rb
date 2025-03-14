class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https:cs.symfony.com"
  # Bump to php 8.4 on the next release, if possible.
  url "https:github.comPHP-CS-FixerPHP-CS-Fixerreleasesdownloadv3.72.0php-cs-fixer.phar"
  sha256 "f4d7037147a7cab3c589e6204edde220d946f3b00e424560c15eca6368e613d5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cd151df867bfae680d8aefb7a05361c930ea42d9b134eae421c25326a1eddfb5"
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