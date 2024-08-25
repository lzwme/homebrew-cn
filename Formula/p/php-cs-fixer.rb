class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https:cs.symfony.com"
  url "https:github.comPHP-CS-FixerPHP-CS-Fixerreleasesdownloadv3.62.0php-cs-fixer.phar"
  sha256 "67f90074a21f99407d77cac3a365cd795d5180b3c5e4b64ca38ae78d4a2a4d5c"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "54c36ddbc898f40e4f819163e38d90fab8fde50ab563843891e18ddd67787d28"
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