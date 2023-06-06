class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://ghproxy.com/https://github.com/phpstan/phpstan/releases/download/1.10.16/phpstan.phar"
  sha256 "0a840de5dde89fc41f78b6da5a50889e1c2610d7a79d2a592bd737ea6ae370fa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "868aa2cd411b97ee3c73ae5ee219bfd4afa5cabd065d3c0094030cbeaa358231"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "868aa2cd411b97ee3c73ae5ee219bfd4afa5cabd065d3c0094030cbeaa358231"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "868aa2cd411b97ee3c73ae5ee219bfd4afa5cabd065d3c0094030cbeaa358231"
    sha256 cellar: :any_skip_relocation, ventura:        "5c968eb778bcd80d5481eff616c361c965d8ed13c8505fbcc5e7b7217da6a88b"
    sha256 cellar: :any_skip_relocation, monterey:       "5c968eb778bcd80d5481eff616c361c965d8ed13c8505fbcc5e7b7217da6a88b"
    sha256 cellar: :any_skip_relocation, big_sur:        "5c968eb778bcd80d5481eff616c361c965d8ed13c8505fbcc5e7b7217da6a88b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "868aa2cd411b97ee3c73ae5ee219bfd4afa5cabd065d3c0094030cbeaa358231"
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