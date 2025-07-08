class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://ghfast.top/https://github.com/PHP-CS-Fixer/PHP-CS-Fixer/releases/download/v3.82.0/php-cs-fixer.phar"
  sha256 "768ff17d386f114ce84fd0951864639e8f2fe8595b9f3c9916374bbe198148c8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "72289eedf7568ba10756a0d44633db4049610dd2f4aeae6fe2dfa90eb19ee8ec"
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