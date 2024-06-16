class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https:cs.symfony.com"
  url "https:github.comPHP-CS-FixerPHP-CS-Fixerreleasesdownloadv3.59.1php-cs-fixer.phar"
  sha256 "4a5af4a4dc349dce27f144425dc48b31bf0a81ddea7a31d3b0a8a5c6035678b0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "503ac986add07beaa6b9f67fd2cf098a4aea3d13fac27d5e53cb8624bf9573fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "503ac986add07beaa6b9f67fd2cf098a4aea3d13fac27d5e53cb8624bf9573fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "503ac986add07beaa6b9f67fd2cf098a4aea3d13fac27d5e53cb8624bf9573fd"
    sha256 cellar: :any_skip_relocation, sonoma:         "503ac986add07beaa6b9f67fd2cf098a4aea3d13fac27d5e53cb8624bf9573fd"
    sha256 cellar: :any_skip_relocation, ventura:        "503ac986add07beaa6b9f67fd2cf098a4aea3d13fac27d5e53cb8624bf9573fd"
    sha256 cellar: :any_skip_relocation, monterey:       "503ac986add07beaa6b9f67fd2cf098a4aea3d13fac27d5e53cb8624bf9573fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24daa46bfe3356604f510a14c5389728ea020387f9925b05430ff1663414d3da"
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