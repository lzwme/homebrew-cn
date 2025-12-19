class PhpIntl < Formula
  desc "PHP internationalization extension"
  homepage "https://www.php.net/manual/en/book.intl.php"
  url "https://www.php.net/distributions/php-8.5.1.tar.xz"
  mirror "https://fossies.org/linux/www/php-8.5.1.tar.xz"
  sha256 "3f5bf99ce81201f526d25e288eddb2cfa111d068950d1e9a869530054ff98815"
  license "PHP-3.01"
  head "https://github.com/php/php-src.git", branch: "master"

  livecheck do
    formula "php"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a476f3ad5c870e1c71a119df7dd2101c9b403677342b2a853b7116ee6ffdb4d8"
    sha256 cellar: :any,                 arm64_sequoia: "aea7f1cf759294e347bf5aba9c910a8073bbf12853444b3a9fbedbcf1a5f6781"
    sha256 cellar: :any,                 arm64_sonoma:  "fe45fa035259913f9f17ad05bf70313274617b5969d8072858c1c1c13751d068"
    sha256 cellar: :any,                 sonoma:        "9c8a81dbceac1b88d337a9864f4452c6cf86f0e7118cc16f9cc2cae8894291fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60862312afa91a9d0a2a2794b398f13b96c79f9cb5567d8631e40df1be7f43df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6420e3d58ff6d6097c3c3a286f193db822040cdd2f3a1fba0975508ee02832c"
  end

  depends_on "pkgconf" => :build
  depends_on "icu4c@78"
  depends_on "php"

  def php
    # Always use matching PHP version
    Formula[name.sub("-intl", "")]
  end

  def install
    # Keep aligned with PHP formula
    extension_dir = Utils.safe_popen_read(php.bin/"php-config", "--extension-dir").chomp
    extension_dir = lib/"php/pecl"/File.basename(extension_dir)

    cd "ext/intl" do
      system "phpize"
      system "./configure"
      system "make"
      system "make", "install", "EXTENSION_DIR=#{extension_dir}"
    end
    rm(%w[NEWS README.md])

    # Automatically load extension on install and unload on uninstall or unlink
    (prefix/"etc/php/#{version.major_minor}/conf.d/ext-intl.ini").write <<~INI
      [intl]
      extension="#{extension_dir}/intl.so"
    INI
  end

  test do
    (testpath/"test.php").write <<~PHP
      <?php
      $formatter = new NumberFormatter('en_US', NumberFormatter::DECIMAL);
      echo $formatter->format(1234567), PHP_EOL;

      $formatter = new MessageFormatter('de_DE', '{0,number,#,###.##} MB');
      echo $formatter->format([12345.6789]);
      ?>
    PHP
    assert_equal "1,234,567\n12.345,68 MB", shell_output("#{php.bin}/php test.php")
    assert_match "intl", shell_output("#{php.bin}/php -m")
  end
end