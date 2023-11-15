class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://ghproxy.com/https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v3.38.2/php-cs-fixer.phar"
  sha256 "cb839aee98c0f8928a5449a921c3e70b5b3fea3f15cda5e8f736da32a6b99ddd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cc6960b858c3fcfa00b4e7e9e99558f3f0c1bbce2e2b2a83307979ebb6506854"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc6960b858c3fcfa00b4e7e9e99558f3f0c1bbce2e2b2a83307979ebb6506854"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc6960b858c3fcfa00b4e7e9e99558f3f0c1bbce2e2b2a83307979ebb6506854"
    sha256 cellar: :any_skip_relocation, sonoma:         "cc6960b858c3fcfa00b4e7e9e99558f3f0c1bbce2e2b2a83307979ebb6506854"
    sha256 cellar: :any_skip_relocation, ventura:        "cc6960b858c3fcfa00b4e7e9e99558f3f0c1bbce2e2b2a83307979ebb6506854"
    sha256 cellar: :any_skip_relocation, monterey:       "cc6960b858c3fcfa00b4e7e9e99558f3f0c1bbce2e2b2a83307979ebb6506854"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2f086447741beef14759c3cc7630eb8fdebca4a6011c9916d9f6f3e0c5e39cc"
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