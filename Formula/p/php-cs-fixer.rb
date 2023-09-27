class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://ghproxy.com/https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v3.29.0/php-cs-fixer.phar"
  sha256 "d1abb2793ac7b3874c04826a3ed8e6d1ff8778979a05d897f069d0d07fa1b588"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0f6b5aad6b7e010e1e7f2513fe1665b45d5d344125e1d59122bed297d668ff4c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f6b5aad6b7e010e1e7f2513fe1665b45d5d344125e1d59122bed297d668ff4c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f6b5aad6b7e010e1e7f2513fe1665b45d5d344125e1d59122bed297d668ff4c"
    sha256 cellar: :any_skip_relocation, sonoma:         "0f6b5aad6b7e010e1e7f2513fe1665b45d5d344125e1d59122bed297d668ff4c"
    sha256 cellar: :any_skip_relocation, ventura:        "0f6b5aad6b7e010e1e7f2513fe1665b45d5d344125e1d59122bed297d668ff4c"
    sha256 cellar: :any_skip_relocation, monterey:       "0f6b5aad6b7e010e1e7f2513fe1665b45d5d344125e1d59122bed297d668ff4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f24386a4865adb94c840ef06afa958e92071d82d4c00dd57f4460592fff2e713"
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