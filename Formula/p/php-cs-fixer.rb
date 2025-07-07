class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  # Bump to php 8.4 on the next release, if possible.
  url "https://ghfast.top/https://github.com/PHP-CS-Fixer/PHP-CS-Fixer/releases/download/v3.80.0/php-cs-fixer.phar"
  sha256 "7b81b2f9dd52dd9a59a98f6c5e5956320ac2623b77196d7d6edae7664f116642"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f6a296703ce20f8afb41e48c2278e86b23ec8da1cc2f76f918521d8e08817ea4"
  end

  depends_on "php@8.3" # php 8.4 support milestone, https://github.com/PHP-CS-Fixer/PHP-CS-Fixer/milestone/173

  def install
    libexec.install "php-cs-fixer.phar"

    (bin/"php-cs-fixer").write <<~PHP
      #!#{Formula["php@8.3"].opt_bin}/php
      <?php require '#{libexec}/php-cs-fixer.phar';
    PHP
  end

  test do
    (testpath/"test.php").write <<~PHP
      <?php $this->foo(   'homebrew rox'   );
    PHP
    (testpath/"correct_test.php").write <<~PHP
      <?php

      $this->foo('homebrew rox');
    PHP

    system bin/"php-cs-fixer", "fix", "test.php"
    assert compare_file("test.php", "correct_test.php")
  end
end