class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https:cs.symfony.com"
  url "https:github.comPHP-CS-FixerPHP-CS-Fixerreleasesdownloadv3.47.1php-cs-fixer.phar"
  sha256 "c56dbfcfd4f6ae24883f74530e93eb2f09582a1fc60472e82d33355ec28ddc6f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dd603622c9948fa699c0d16b556792e01d9c564a2cb5d2e5b49c9a697c47c7b9"
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