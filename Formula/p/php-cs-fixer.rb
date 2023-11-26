class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://ghproxy.com/https://github.com/PHP-CS-Fixer/PHP-CS-Fixer/releases/download/v3.39.1/php-cs-fixer.phar"
  sha256 "11f3e8c9ad82e8d5823bc506c171734e2ed054d4292b443753e48423ccb70848"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5b0b2764395913ec286901e4df5085111132289a58ccf03680aba145b458f9e6"
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