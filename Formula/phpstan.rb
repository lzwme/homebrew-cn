class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://ghproxy.com/https://github.com/phpstan/phpstan/releases/download/1.10.19/phpstan.phar"
  sha256 "3166808b36979a24810e8afad0c26c5f37655e847131f10c34d443ee13571ffb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e54c0d0c518f838200a52db5f54a93a2c8e8550f22ca068b893bdf70860233b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e54c0d0c518f838200a52db5f54a93a2c8e8550f22ca068b893bdf70860233b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e54c0d0c518f838200a52db5f54a93a2c8e8550f22ca068b893bdf70860233b5"
    sha256 cellar: :any_skip_relocation, ventura:        "c99c74f891533f43687245c627861cd3fd0caff23483e5557729ac4baca6f858"
    sha256 cellar: :any_skip_relocation, monterey:       "c99c74f891533f43687245c627861cd3fd0caff23483e5557729ac4baca6f858"
    sha256 cellar: :any_skip_relocation, big_sur:        "c99c74f891533f43687245c627861cd3fd0caff23483e5557729ac4baca6f858"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e54c0d0c518f838200a52db5f54a93a2c8e8550f22ca068b893bdf70860233b5"
  end

  depends_on "php" => :test

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    on_intel do
      pour_bottle? only_if: :default_prefix
    end
  end

  def install
    bin.install "phpstan.phar" => "phpstan"
  end

  test do
    (testpath/"src/autoload.php").write <<~EOS
      <?php
      spl_autoload_register(
          function($class) {
              static $classes = null;
              if ($classes === null) {
                  $classes = array(
                      'email' => '/Email.php'
                  );
              }
              $cn = strtolower($class);
              if (isset($classes[$cn])) {
                  require __DIR__ . $classes[$cn];
              }
          },
          true,
          false
      );
    EOS

    (testpath/"src/Email.php").write <<~EOS
      <?php
        declare(strict_types=1);

        final class Email
        {
            private string $email;

            private function __construct(string $email)
            {
                $this->ensureIsValidEmail($email);

                $this->email = $email;
            }

            public static function fromString(string $email): self
            {
                return new self($email);
            }

            public function __toString(): string
            {
                return $this->email;
            }

            private function ensureIsValidEmail(string $email): void
            {
                if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
                    throw new InvalidArgumentException(
                        sprintf(
                            '"%s" is not a valid email address',
                            $email
                        )
                    );
                }
            }
        }
    EOS
    assert_match(/^\n \[OK\] No errors/,
      shell_output("#{bin}/phpstan analyse --level max --autoload-file src/autoload.php src/Email.php"))
  end
end