class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://ghproxy.com/https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v3.27.0/php-cs-fixer.phar"
  sha256 "bc035cfe984cfc694d2fcfe87b5737cfa841133712ebdab58effe8e4426e59ed"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85b80944131a1756cfbeb017b8d1ceec29097f572dee6700563cdf1425034230"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85b80944131a1756cfbeb017b8d1ceec29097f572dee6700563cdf1425034230"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "85b80944131a1756cfbeb017b8d1ceec29097f572dee6700563cdf1425034230"
    sha256 cellar: :any_skip_relocation, ventura:        "85b80944131a1756cfbeb017b8d1ceec29097f572dee6700563cdf1425034230"
    sha256 cellar: :any_skip_relocation, monterey:       "85b80944131a1756cfbeb017b8d1ceec29097f572dee6700563cdf1425034230"
    sha256 cellar: :any_skip_relocation, big_sur:        "85b80944131a1756cfbeb017b8d1ceec29097f572dee6700563cdf1425034230"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "105594578808d284c74f7e7669b7b28091953b6119149577b0e0ecf8f2a73413"
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