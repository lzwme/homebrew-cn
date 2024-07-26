class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https:cs.symfony.com"
  url "https:github.comPHP-CS-FixerPHP-CS-Fixerreleasesdownloadv3.60.0php-cs-fixer.phar"
  sha256 "f18ce5ce2ed64ffee516dee061af7b5a0aa586c98ebf400099ba4d8f93f8c91c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4d8c051e885f58d6a4f0c7b764e877455a3ef93428dc14e699ad51c50e8d6b3c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d8c051e885f58d6a4f0c7b764e877455a3ef93428dc14e699ad51c50e8d6b3c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d8c051e885f58d6a4f0c7b764e877455a3ef93428dc14e699ad51c50e8d6b3c"
    sha256 cellar: :any_skip_relocation, sonoma:         "4d8c051e885f58d6a4f0c7b764e877455a3ef93428dc14e699ad51c50e8d6b3c"
    sha256 cellar: :any_skip_relocation, ventura:        "4d8c051e885f58d6a4f0c7b764e877455a3ef93428dc14e699ad51c50e8d6b3c"
    sha256 cellar: :any_skip_relocation, monterey:       "4d8c051e885f58d6a4f0c7b764e877455a3ef93428dc14e699ad51c50e8d6b3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e860d34ba4ecc9b4806a3bc0e060fa2a958e104d5974426b1d2bbd040866e85b"
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