class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https:cs.symfony.com"
  url "https:github.comPHP-CS-FixerPHP-CS-Fixerreleasesdownloadv3.58.1php-cs-fixer.phar"
  sha256 "e02a640b22e704b95fae96c1a1fde51f9486b314f666ed3d28ed293dadb61d9c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dbab06d9fb46d4a7691d07a47351ddb6dc542fd9afb613bd89c4cf3f0517655f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dbab06d9fb46d4a7691d07a47351ddb6dc542fd9afb613bd89c4cf3f0517655f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbab06d9fb46d4a7691d07a47351ddb6dc542fd9afb613bd89c4cf3f0517655f"
    sha256 cellar: :any_skip_relocation, sonoma:         "dbab06d9fb46d4a7691d07a47351ddb6dc542fd9afb613bd89c4cf3f0517655f"
    sha256 cellar: :any_skip_relocation, ventura:        "dbab06d9fb46d4a7691d07a47351ddb6dc542fd9afb613bd89c4cf3f0517655f"
    sha256 cellar: :any_skip_relocation, monterey:       "dbab06d9fb46d4a7691d07a47351ddb6dc542fd9afb613bd89c4cf3f0517655f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "546c01a8738c449b0fec8f4ba04666ae5d4b37498dc0d3057f593ca558f71c8d"
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