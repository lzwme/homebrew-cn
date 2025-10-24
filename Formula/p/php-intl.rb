class PhpIntl < Formula
  desc "PHP internationalization extension"
  homepage "https://www.php.net/manual/en/book.intl.php"
  url "https://www.php.net/distributions/php-8.4.14.tar.xz"
  mirror "https://fossies.org/linux/www/php-8.4.14.tar.xz"
  sha256 "bac90ee7cf738e814c89b6b27d4d2c4b70e50942a420837e1a22f5fd5f9867a3"
  license "PHP-3.01"
  head "https://github.com/php/php-src.git", branch: "master"

  livecheck do
    formula "php"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "09f4c2e892fe872c144972625e7fefd09939214514eafec9edfda569f5f60846"
    sha256 cellar: :any,                 arm64_sequoia: "cb523e23e9d373ee4b4a69aaef32b945cf5bb17f0c1a94ec19981e819d22c841"
    sha256 cellar: :any,                 arm64_sonoma:  "8901b913e74a06569a7f841c20185e8f89f713ad3719ee960bc1d3917e165bd1"
    sha256 cellar: :any,                 sonoma:        "3efa5c95b6ba9ab6ea62b6e05cf3e503e1a63f6960bfa45f658cea3099ecd9d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a3e31797fdfd258f11d9a3dd2202fa597ee418fdbe44c9d3e7ad835a7c39030"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc8243c435f6e71cd0450e4ecdab30093a436e99e04bf3ea8e741a746adb28af"
  end

  depends_on "pkgconf" => :build
  depends_on "icu4c@77"
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