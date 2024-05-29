class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https:cs.symfony.com"
  url "https:github.comPHP-CS-FixerPHP-CS-Fixerreleasesdownloadv3.58.0php-cs-fixer.phar"
  sha256 "cdc0032732bae0a89d28f12c6bcee173507f3460151de96c7c35e4fa66bd02a9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d470e78bf1fe753f8f55d9446d1e665c9b61a25f9da6f5e670326f5e4639f897"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d470e78bf1fe753f8f55d9446d1e665c9b61a25f9da6f5e670326f5e4639f897"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d470e78bf1fe753f8f55d9446d1e665c9b61a25f9da6f5e670326f5e4639f897"
    sha256 cellar: :any_skip_relocation, sonoma:         "d470e78bf1fe753f8f55d9446d1e665c9b61a25f9da6f5e670326f5e4639f897"
    sha256 cellar: :any_skip_relocation, ventura:        "d470e78bf1fe753f8f55d9446d1e665c9b61a25f9da6f5e670326f5e4639f897"
    sha256 cellar: :any_skip_relocation, monterey:       "d470e78bf1fe753f8f55d9446d1e665c9b61a25f9da6f5e670326f5e4639f897"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "887580a1dce7e250e0619200a4bc6f180c9f782824a01e1242ceebada9b2b362"
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