class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://ghproxy.com/https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v3.24.0/php-cs-fixer.phar"
  sha256 "082015ee6c3911a71d864699d75169d8f2d705fb3b34cccf1b1d54891d4e2906"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d64b443abad57467eefce034e7cba58c425c370570c5ac97d21c2e0f11878aaf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d64b443abad57467eefce034e7cba58c425c370570c5ac97d21c2e0f11878aaf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d64b443abad57467eefce034e7cba58c425c370570c5ac97d21c2e0f11878aaf"
    sha256 cellar: :any_skip_relocation, ventura:        "d64b443abad57467eefce034e7cba58c425c370570c5ac97d21c2e0f11878aaf"
    sha256 cellar: :any_skip_relocation, monterey:       "d64b443abad57467eefce034e7cba58c425c370570c5ac97d21c2e0f11878aaf"
    sha256 cellar: :any_skip_relocation, big_sur:        "d64b443abad57467eefce034e7cba58c425c370570c5ac97d21c2e0f11878aaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "473373fe1c63ff9c12433bb939580fabdb568920d009c1a6f48c6ca84d774cf1"
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