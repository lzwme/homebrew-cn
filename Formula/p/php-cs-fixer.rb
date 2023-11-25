class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://ghproxy.com/https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v3.39.0/php-cs-fixer.phar"
  sha256 "c23fac1632666adb2cb48d5941a2c19a05b32135b39b2f98fe05607d241cdb0a"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f200d20faa422963c31b751721de4e5c38e18bd7bc4727b39fed6bff40d0ae79"
  end

  depends_on "php@8.2"

  def install
    libexec.install "php-cs-fixer.phar"

    (bin/"php-cs-fixer").write <<~EOS
      #!#{Formula["php@8.2"].opt_bin}/php
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