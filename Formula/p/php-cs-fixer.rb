class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https:cs.symfony.com"
  url "https:github.comPHP-CS-FixerPHP-CS-Fixerreleasesdownloadv3.57.0php-cs-fixer.phar"
  sha256 "57bc7fb20d56c5c4d9853dd61bfa53da73ced8c2d65030a951a3a3d6b448602d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3d84a44c6a1697388333fd3f7f18c68cb0c9a2124c8644a29c19e5cbb0b950ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8bbbdebd04a7bc6e07548cd8e1cedb55f07519ff34e7ac804b987a533a7573a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19179c383a305e78a081c9e1ff3745af82dd71c289d4001c9723622b0b378b91"
    sha256 cellar: :any_skip_relocation, sonoma:         "880096079194ecc4d7e17f7c3429a0bc483a71bbe9e1b2152b390d166901c840"
    sha256 cellar: :any_skip_relocation, ventura:        "cbf62220c75098cd37c52286450b795e35a5d488e0315bd71e921a17a77ccec5"
    sha256 cellar: :any_skip_relocation, monterey:       "3e9cdba8c00154d45be166dd4ca406bb8b57f0e346cd4e9fd6ae6bd8dffb615c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29bb334bf2a77d2cb21642772816fb666166e753bf2b5e2cbee22eb76ca01ef2"
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