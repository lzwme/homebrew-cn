class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  # Bump to php 8.4 on the next release, if possible.
  url "https://ghfast.top/https://github.com/PHP-CS-Fixer/PHP-CS-Fixer/releases/download/v3.77.0/php-cs-fixer.phar"
  sha256 "875c6c4125f94dd8a69c45a5b5083e6a671730b09804d3a8fac137b98353c885"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "22f8303a1592ed352979f92fe1d8b279a63427984d4bd9f3de2f8e7e085d0144"
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