class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://ghproxy.com/https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v3.26.1/php-cs-fixer.phar"
  sha256 "11c121a2fd60a03fa4462e4820ec332f9b3917b9f779a1f5c000bb0949d525cf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e90a3acaa4347240ace845d4d1181d4c40586860f4c6f39780ffc81fa20a1039"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e90a3acaa4347240ace845d4d1181d4c40586860f4c6f39780ffc81fa20a1039"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e90a3acaa4347240ace845d4d1181d4c40586860f4c6f39780ffc81fa20a1039"
    sha256 cellar: :any_skip_relocation, ventura:        "e90a3acaa4347240ace845d4d1181d4c40586860f4c6f39780ffc81fa20a1039"
    sha256 cellar: :any_skip_relocation, monterey:       "e90a3acaa4347240ace845d4d1181d4c40586860f4c6f39780ffc81fa20a1039"
    sha256 cellar: :any_skip_relocation, big_sur:        "e90a3acaa4347240ace845d4d1181d4c40586860f4c6f39780ffc81fa20a1039"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4f3bbca9ec45bf44f0f743e24f4d18c0716d7f31e81280f6731220b09818674"
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