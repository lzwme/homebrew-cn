class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://ghproxy.com/https://github.com/PHP-CS-Fixer/PHP-CS-Fixer/releases/download/v3.40.2/php-cs-fixer.phar"
  sha256 "b63b6a8b996ed631360acc7a1a005ee8bee38ab87c42917c644ef8b148d2acdb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7bbfca8a6f1749f91db70d9ca793f5b46e5b52f18126df4764fceaec739d1ca4"
  end

  depends_on "php"

  def install
    libexec.install "php-cs-fixer.phar"

    (bin/"php-cs-fixer").write <<~EOS
      #!#{Formula["php"].opt_bin}/php
      <?php require '#{libexec}/php-cs-fixer.phar';
    EOS
  end

  test do
    (testpath/"test.php").write <<~EOS
      <?php $this->foo(   'homebrew rox'   );
    EOS
    (testpath/"correct_test.php").write <<~EOS
      <?php

      $this->foo('homebrew rox');
    EOS

    system bin/"php-cs-fixer", "fix", "test.php"
    assert compare_file("test.php", "correct_test.php")
  end
end