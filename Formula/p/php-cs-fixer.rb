class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://ghfast.top/https://github.com/PHP-CS-Fixer/PHP-CS-Fixer/releases/download/v3.89.0/php-cs-fixer.phar"
  sha256 "1fdf03972c4422f873c027e59d81166e419afb2a6b6add8a5b690d995eeb74ad"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "24a5a86c035d04b8181554bdb3ba1e2756b3db3a20e7f50ea029ddcd18dfe0e7"
  end

  depends_on "php"

  def install
    libexec.install "php-cs-fixer.phar"

    (bin/"php-cs-fixer").write <<~PHP
      #!#{Formula["php"].opt_bin}/php
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