class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://ghfast.top/https://github.com/PHP-CS-Fixer/PHP-CS-Fixer/releases/download/v3.89.2/php-cs-fixer.phar"
  sha256 "66ab5a49212208edfd185da855ca965f1eaa5f2f00aad8c2091cb6a092897a17"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a1a04bbec10d6e53c6bfca218310d1bbb3acf7e6bc1516653b3f4b4e00ab020f"
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