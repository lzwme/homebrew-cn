class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https:cs.symfony.com"
  url "https:github.comPHP-CS-FixerPHP-CS-Fixerreleasesdownloadv3.56.0php-cs-fixer.phar"
  sha256 "38f0131e73b215de4b4913f189994d953184e7c92e2816a445d221856d3cd5a2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cafe340e2907371e3df4a5b8f4851e5d94461a06546c3d923084440c21b9ee3d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4fd9b7f5aedd853918b99b0aaf9cf13d60cfb073a7d68db77c71a446827e6d3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26b27c36d534d45096c91844885fdc514642572f6d23528ae2304b4b93640784"
    sha256 cellar: :any_skip_relocation, sonoma:         "d145bbaa3a874209a9d4f7ae049eeed1b772588fdaf99d45701a59046fcfe168"
    sha256 cellar: :any_skip_relocation, ventura:        "250b732c5e9c2e0a300200ed74f829f4acea40c62e99f2e3ea4f0de89eddd91f"
    sha256 cellar: :any_skip_relocation, monterey:       "a2e37026ea417cd6fa356b3f90f9184eef884d2c4394fa9238e358dd423a5c8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26fbed8adc7139b5e6738fd10a79f19c416834bd900da417ace18a3a9beb01ad"
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