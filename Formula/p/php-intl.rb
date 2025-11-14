class PhpIntl < Formula
  desc "PHP internationalization extension"
  homepage "https://www.php.net/manual/en/book.intl.php"
  url "https://www.php.net/distributions/php-8.4.14.tar.xz"
  mirror "https://fossies.org/linux/www/php-8.4.14.tar.xz"
  sha256 "bac90ee7cf738e814c89b6b27d4d2c4b70e50942a420837e1a22f5fd5f9867a3"
  license "PHP-3.01"
  revision 1
  head "https://github.com/php/php-src.git", branch: "master"

  livecheck do
    formula "php"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "794170d5ef7525b62b2ce2f00fe72ca3d5985e250b1d34c7952b0894fb95d771"
    sha256 cellar: :any,                 arm64_sequoia: "3f006580bd9206bb4bc4f10e80ad7902d47b2b4aaacde709c6db6b21c80267a0"
    sha256 cellar: :any,                 arm64_sonoma:  "209ddbaf0a542ddc1a67d45decc6bda6981d746e5b39f3a22ee0ce19598334fa"
    sha256 cellar: :any,                 sonoma:        "6b04b6c178370d801c9e23549c8df6e575c621a4605cfd6db0f73ec2e07199bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "110315ed6d2e9f99b04e0825ec1eafe93cf4314bfd77da16a24b5a19b64efb56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "290ac60b5cb760aa3c816796ca67d972b8f73c8a4a0e652cbd544b48625b6b33"
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