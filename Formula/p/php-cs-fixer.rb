class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://ghfast.top/https://github.com/PHP-CS-Fixer/PHP-CS-Fixer/releases/download/v3.95.3/php-cs-fixer.phar"
  sha256 "38e879d4a02ac754ede41c4a1bb3113b0da0f17539e52fed6b177c76ea56043a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3734624654858f0885a4ca7ecd346d827dcacf8028b32523f128245f83b64315"
  end

  depends_on "php"

  def install
    libexec.install "php-cs-fixer.phar"

    (bin/"php-cs-fixer").write <<~PHP
      #!#{Formula["php"].opt_bin}/php
      <?php require '#{libexec}/php-cs-fixer.phar';
    PHP
  end

  test do
    (testpath/"composer.json").write <<~JSON
      {
        "require": {
          "php": ">=8.0"
        }
      }
    JSON
    (testpath/"test.php").write <<~PHP
      <?php $this->foo(   'homebrew rox'   );
    PHP
    (testpath/"correct_test.php").write <<~PHP
      <?php

      $this->foo('homebrew rox');
    PHP

    (testpath/".php-cs-fixer.dist.php").write <<~PHP
      <?php

      $finder = PhpCsFixer\\Finder::create()
          ->in(__DIR__);

      return (new PhpCsFixer\\Config())
          ->setRiskyAllowed(false)
          ->setRules([
              '@PSR12' => true,
          ])
          ->setFinder($finder);
    PHP

    system bin/"php-cs-fixer", "fix", "test.php"
    assert compare_file("test.php", "correct_test.php")
  end
end