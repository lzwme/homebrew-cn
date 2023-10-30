class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://ghproxy.com/https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v3.37.1/php-cs-fixer.phar"
  sha256 "cca3e4c473c5f12b4382cd430be58a56fa37546cecfa52449511e588a517b5cc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c858725009e06c23c494e79390f52b5a2d4ad27a215dfffb6ed9f080ca5ba631"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c858725009e06c23c494e79390f52b5a2d4ad27a215dfffb6ed9f080ca5ba631"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c858725009e06c23c494e79390f52b5a2d4ad27a215dfffb6ed9f080ca5ba631"
    sha256 cellar: :any_skip_relocation, sonoma:         "c858725009e06c23c494e79390f52b5a2d4ad27a215dfffb6ed9f080ca5ba631"
    sha256 cellar: :any_skip_relocation, ventura:        "c858725009e06c23c494e79390f52b5a2d4ad27a215dfffb6ed9f080ca5ba631"
    sha256 cellar: :any_skip_relocation, monterey:       "c858725009e06c23c494e79390f52b5a2d4ad27a215dfffb6ed9f080ca5ba631"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8449edb83e3ef1a31e84348084706fa4c56f2ee6ffb80772d0c51a05dd2ddf33"
  end

  depends_on "php"

  def install
    libexec.install "php-cs-fixer.phar"

    (bin/"php-cs-fixer").write <<~EOS
      #!#{Formula["php"].opt_bin}/php
      <?php require '#{libexec}/php-cs-fixer.phar';
    EOS
  end

  test do
    (testpath/"test.php").write <<~EOS
      <?php $this->foo(   'homebrew rox'   );
    EOS
    (testpath/"correct_test.php").write <<~EOS
      <?php

      $this->foo('homebrew rox');
    EOS

    system bin/"php-cs-fixer", "fix", "test.php"
    assert compare_file("test.php", "correct_test.php")
  end
end