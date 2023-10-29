class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://ghproxy.com/https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v3.37.0/php-cs-fixer.phar"
  sha256 "3859076e23ef5380d8bd4c9494cd4c830e529d8a88edacfb592a9d81e26924c7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c2dd538d1976626d47c5274808b6141c76c8ea59a7ffdd7f2b5b746abf03dad9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c2dd538d1976626d47c5274808b6141c76c8ea59a7ffdd7f2b5b746abf03dad9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2dd538d1976626d47c5274808b6141c76c8ea59a7ffdd7f2b5b746abf03dad9"
    sha256 cellar: :any_skip_relocation, sonoma:         "c2dd538d1976626d47c5274808b6141c76c8ea59a7ffdd7f2b5b746abf03dad9"
    sha256 cellar: :any_skip_relocation, ventura:        "c2dd538d1976626d47c5274808b6141c76c8ea59a7ffdd7f2b5b746abf03dad9"
    sha256 cellar: :any_skip_relocation, monterey:       "c2dd538d1976626d47c5274808b6141c76c8ea59a7ffdd7f2b5b746abf03dad9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19a52d9815767313b71120fbf48aefbedf5dd672e9e7c4668c3e2e5d13f278be"
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