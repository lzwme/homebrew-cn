class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://ghproxy.com/https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v3.26.0/php-cs-fixer.phar"
  sha256 "eb5525d55fe845b423da9d8b327ff0dd5a20025d03cddaa08aec95fbef6b2501"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ecbe25915cac2cddd98a51de7500121c4123226040e92231eb09ceb9d893e33d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ecbe25915cac2cddd98a51de7500121c4123226040e92231eb09ceb9d893e33d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ecbe25915cac2cddd98a51de7500121c4123226040e92231eb09ceb9d893e33d"
    sha256 cellar: :any_skip_relocation, ventura:        "ecbe25915cac2cddd98a51de7500121c4123226040e92231eb09ceb9d893e33d"
    sha256 cellar: :any_skip_relocation, monterey:       "ecbe25915cac2cddd98a51de7500121c4123226040e92231eb09ceb9d893e33d"
    sha256 cellar: :any_skip_relocation, big_sur:        "ecbe25915cac2cddd98a51de7500121c4123226040e92231eb09ceb9d893e33d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab726f314e82a81b76993c3f7ac4a2f94f6d6647fd289f988d484155fc9170f2"
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