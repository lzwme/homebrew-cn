class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https:cs.symfony.com"
  url "https:github.comPHP-CS-FixerPHP-CS-Fixerreleasesdownloadv3.57.1php-cs-fixer.phar"
  sha256 "a25dc12dbfd15f61a63cecba4af2981ef95d07b56934097721d08803de64b021"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d2b3cb8eb3916ed7f5a62061f71157109132130807134d7913a21597d9f535a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "01b8226d94691c9ce41715d9ac2cbe2733ba5b2bcb7f438855564efa1aaa8bbe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69fa0f227e0288078422c5b9673c0bd1bb9513bb086c0cc1ef2cabbe85447f60"
    sha256 cellar: :any_skip_relocation, sonoma:         "18b6108a9eb7626a0e0046b630252933916548ebd17d84cceda01811bc13d536"
    sha256 cellar: :any_skip_relocation, ventura:        "26d4273b485a3286e546de8a84ee9b00433247a4f54a80aed3df3db6920c2bf2"
    sha256 cellar: :any_skip_relocation, monterey:       "b6846ab47c7bda4a0981a3b39f4ee00f1c31f5f0b7ddef7611e6258f1e022af8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96617faa8aee05036d15e6bf879cc46c12697d6d3a85616e1c1b0aae642c1222"
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