class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https:cs.symfony.com"
  # Bump to php 8.4 on the next release, if possible.
  url "https:github.comPHP-CS-FixerPHP-CS-Fixerreleasesdownloadv3.69.1php-cs-fixer.phar"
  sha256 "e2085d8d052c498233a98f9d844c56fb496bae8122a2211d0eebc8abc785081a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1b27d5f44de5de2e7f48f802cbf36218a612774e4e9215b7b6138131829a480f"
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