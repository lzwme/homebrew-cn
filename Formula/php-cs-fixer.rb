class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://ghproxy.com/https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v3.21.1/php-cs-fixer.phar"
  sha256 "7ff843da2b7f976856195a085d00496030bbb3b24f484fbb4736e975e34d46f8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4416af7179ad629dfd23af1b548421ad647724cf80b813bc45d0a98fa41b35b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4416af7179ad629dfd23af1b548421ad647724cf80b813bc45d0a98fa41b35b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4416af7179ad629dfd23af1b548421ad647724cf80b813bc45d0a98fa41b35b2"
    sha256 cellar: :any_skip_relocation, ventura:        "4416af7179ad629dfd23af1b548421ad647724cf80b813bc45d0a98fa41b35b2"
    sha256 cellar: :any_skip_relocation, monterey:       "4416af7179ad629dfd23af1b548421ad647724cf80b813bc45d0a98fa41b35b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "4416af7179ad629dfd23af1b548421ad647724cf80b813bc45d0a98fa41b35b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6962726c5463e0299796cb68ad3ab4a93d024b594f4afc7774b1da593b60db8"
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