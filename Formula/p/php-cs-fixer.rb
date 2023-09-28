class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://ghproxy.com/https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v3.30.0/php-cs-fixer.phar"
  sha256 "bd0368a368168e05f0e7400878bb774bb8a67a5e58fa7efcdb297fd16627c197"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "04557033725417180f5b160e06af28f5b6bb3f992a9b99a76cc8dbfe63636876"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04557033725417180f5b160e06af28f5b6bb3f992a9b99a76cc8dbfe63636876"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04557033725417180f5b160e06af28f5b6bb3f992a9b99a76cc8dbfe63636876"
    sha256 cellar: :any_skip_relocation, sonoma:         "04557033725417180f5b160e06af28f5b6bb3f992a9b99a76cc8dbfe63636876"
    sha256 cellar: :any_skip_relocation, ventura:        "04557033725417180f5b160e06af28f5b6bb3f992a9b99a76cc8dbfe63636876"
    sha256 cellar: :any_skip_relocation, monterey:       "04557033725417180f5b160e06af28f5b6bb3f992a9b99a76cc8dbfe63636876"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05421aa700367416149e7294f38fc8ced7d0b982b477b2fee559e218c15c4dd5"
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