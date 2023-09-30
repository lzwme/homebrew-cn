class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://ghproxy.com/https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v3.34.0/php-cs-fixer.phar"
  sha256 "07082e808118a4a4c0cbe74e5e6e4c7f6b70f9888d67e7e313a6b4d6ea6544b9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2c79dd4793b602f97b899589230dcab6b955eb20b54447330af5fad6dfa5bdf2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c79dd4793b602f97b899589230dcab6b955eb20b54447330af5fad6dfa5bdf2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c79dd4793b602f97b899589230dcab6b955eb20b54447330af5fad6dfa5bdf2"
    sha256 cellar: :any_skip_relocation, sonoma:         "2c79dd4793b602f97b899589230dcab6b955eb20b54447330af5fad6dfa5bdf2"
    sha256 cellar: :any_skip_relocation, ventura:        "2c79dd4793b602f97b899589230dcab6b955eb20b54447330af5fad6dfa5bdf2"
    sha256 cellar: :any_skip_relocation, monterey:       "2c79dd4793b602f97b899589230dcab6b955eb20b54447330af5fad6dfa5bdf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a799f4f8d753de18ff6c17e7a78deb72d7de2b438d449358028c9ba1ed91c91e"
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