class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://ghproxy.com/https://github.com/PHP-CS-Fixer/PHP-CS-Fixer/releases/download/v3.41.0/php-cs-fixer.phar"
  sha256 "1e6ca0dce9cb0d11a279246fceaae67afc660e72e33ec760c9f8ee95dde7c51e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c4b221b83524b9b59506f760fe005a79ff921afe15ee30a2dc8db0b59e902026"
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