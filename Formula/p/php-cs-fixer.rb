class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://ghproxy.com/https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v3.36.0/php-cs-fixer.phar"
  sha256 "5f3cf0fe008789113f5540d6df5137cc0d83ede5017a3cc0b5dd5919f5c76515"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0543fa52aefcaa321b2ef3456920ca08a53da4afa91b4750a0611e1964c5350b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0543fa52aefcaa321b2ef3456920ca08a53da4afa91b4750a0611e1964c5350b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0543fa52aefcaa321b2ef3456920ca08a53da4afa91b4750a0611e1964c5350b"
    sha256 cellar: :any_skip_relocation, sonoma:         "0543fa52aefcaa321b2ef3456920ca08a53da4afa91b4750a0611e1964c5350b"
    sha256 cellar: :any_skip_relocation, ventura:        "0543fa52aefcaa321b2ef3456920ca08a53da4afa91b4750a0611e1964c5350b"
    sha256 cellar: :any_skip_relocation, monterey:       "0543fa52aefcaa321b2ef3456920ca08a53da4afa91b4750a0611e1964c5350b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fef9e6d1e4d3ea27d4fd1e64cba6c38dee409db68b46f983027dde88fd88ab5a"
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