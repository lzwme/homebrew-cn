class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://ghproxy.com/https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v3.15.0/php-cs-fixer.phar"
  sha256 "cd7b675680c8365b67742c77e62b92996e8f3439d314a306ffed86c7a2d6bf1d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "207186e03aa249e12a10380b8798616c700d4c61e8bfcb617ec787fb58e8262c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "207186e03aa249e12a10380b8798616c700d4c61e8bfcb617ec787fb58e8262c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "207186e03aa249e12a10380b8798616c700d4c61e8bfcb617ec787fb58e8262c"
    sha256 cellar: :any_skip_relocation, ventura:        "207186e03aa249e12a10380b8798616c700d4c61e8bfcb617ec787fb58e8262c"
    sha256 cellar: :any_skip_relocation, monterey:       "207186e03aa249e12a10380b8798616c700d4c61e8bfcb617ec787fb58e8262c"
    sha256 cellar: :any_skip_relocation, big_sur:        "207186e03aa249e12a10380b8798616c700d4c61e8bfcb617ec787fb58e8262c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fed11f2e54eaf238a35b2e5767ce218968a55ad755048827eef51ed9beb899f9"
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