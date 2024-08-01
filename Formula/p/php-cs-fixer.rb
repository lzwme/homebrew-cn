class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https:cs.symfony.com"
  url "https:github.comPHP-CS-FixerPHP-CS-Fixerreleasesdownloadv3.61.1php-cs-fixer.phar"
  sha256 "a87859b5692fd309e9e2fef70f3766960c5d98331f44905723bb19182b46a902"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4f91559ed4f9cb57378079b96c1f4cb87b9c791375e8a58a3ef1311ceae6fb78"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f91559ed4f9cb57378079b96c1f4cb87b9c791375e8a58a3ef1311ceae6fb78"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f91559ed4f9cb57378079b96c1f4cb87b9c791375e8a58a3ef1311ceae6fb78"
    sha256 cellar: :any_skip_relocation, sonoma:         "4f91559ed4f9cb57378079b96c1f4cb87b9c791375e8a58a3ef1311ceae6fb78"
    sha256 cellar: :any_skip_relocation, ventura:        "4f91559ed4f9cb57378079b96c1f4cb87b9c791375e8a58a3ef1311ceae6fb78"
    sha256 cellar: :any_skip_relocation, monterey:       "4f91559ed4f9cb57378079b96c1f4cb87b9c791375e8a58a3ef1311ceae6fb78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37bf3e918ba3ca0abc4bcf0e8931b4cbc5784fe7ebdc279a4499afda906d6960"
  end

  depends_on "php"

  def install
    libexec.install "php-cs-fixer.phar"

    (bin"php-cs-fixer").write <<~EOS
      #!#{Formula["php"].opt_bin}php
      <?php require '#{libexec}php-cs-fixer.phar';
    EOS
  end

  test do
    (testpath"test.php").write <<~EOS
      <?php $this->foo(   'homebrew rox'   );
    EOS
    (testpath"correct_test.php").write <<~EOS
      <?php

      $this->foo('homebrew rox');
    EOS

    system bin"php-cs-fixer", "fix", "test.php"
    assert compare_file("test.php", "correct_test.php")
  end
end