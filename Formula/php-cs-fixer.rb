class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://ghproxy.com/https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v3.18.0/php-cs-fixer.phar"
  sha256 "0badc50b105b3c0e0bbcdaa8c68c4fe90fb63e5dc34614e8b39524db49c46abd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c289bfa6d9972fa76709782fe1c82c638dfa586d37671f98bca415996f5173d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c289bfa6d9972fa76709782fe1c82c638dfa586d37671f98bca415996f5173d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c289bfa6d9972fa76709782fe1c82c638dfa586d37671f98bca415996f5173d"
    sha256 cellar: :any_skip_relocation, ventura:        "8c289bfa6d9972fa76709782fe1c82c638dfa586d37671f98bca415996f5173d"
    sha256 cellar: :any_skip_relocation, monterey:       "8c289bfa6d9972fa76709782fe1c82c638dfa586d37671f98bca415996f5173d"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c289bfa6d9972fa76709782fe1c82c638dfa586d37671f98bca415996f5173d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "253a1b1f05bbb97c15ccb979109afb81becbc8b58611c096d09f9c3fb6c5c7e7"
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