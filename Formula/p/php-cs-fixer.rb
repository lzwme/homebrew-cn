class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https:cs.symfony.com"
  url "https:github.comPHP-CS-FixerPHP-CS-Fixerreleasesdownloadv3.57.2php-cs-fixer.phar"
  sha256 "6c15017d83bed49a62f1d9000fa703e479ef97dc80b896120e8431f86a785a50"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4f4ddb1ac29b708883227fee3f6f1e2881bb9ff646cccbd1e2d75e7a890857d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ada1335d570a4e7430c2a5228f658390e10aacd40b782d21b55034961242bde"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ed4517532207d5a145d41601f4515d6e8dcf69547548a3d4476e54d8b184dd9"
    sha256 cellar: :any_skip_relocation, sonoma:         "ef21cc6f576f9a47e4d0fb325e747da131e058cf577ddf3dcdc107c8444c78a9"
    sha256 cellar: :any_skip_relocation, ventura:        "a79c9d97fe96d7f7efba98d3bd7836803ddfcee1a7ab1978939fd9e31eae2ceb"
    sha256 cellar: :any_skip_relocation, monterey:       "dfe0aed9c869d1f11ca0708d86e8fe159ee264b5c6f880de4f323380e2ed068d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c83e73afca76f762f2b0450fea414b5a1c9f07d756b425aec670a2e84916e7e"
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