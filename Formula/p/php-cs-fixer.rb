class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https:cs.symfony.com"
  # Bump to php 8.4 on the next release, if possible.
  url "https:github.comPHP-CS-FixerPHP-CS-Fixerreleasesdownloadv3.66.2php-cs-fixer.phar"
  sha256 "8ab455048a859358b74f5cb791e8d3fceedfa0b087409d02db212b8296bc1120"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "674d0f6813e9eaa2dcb89be9d27ba8e26025a0dee4b32ea43206d1f4e3c0c416"
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