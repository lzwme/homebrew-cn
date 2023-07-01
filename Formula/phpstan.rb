class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://ghproxy.com/https://github.com/phpstan/phpstan/releases/download/1.10.22/phpstan.phar"
  sha256 "6474f0f489859fc460bff343f06767d7a8b135e723075644052825bc9bc4102b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2da1f663a8c7af56ce298e649ffe218d5cbb44e556f61e55929e3c51098eb03"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2da1f663a8c7af56ce298e649ffe218d5cbb44e556f61e55929e3c51098eb03"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a2da1f663a8c7af56ce298e649ffe218d5cbb44e556f61e55929e3c51098eb03"
    sha256 cellar: :any_skip_relocation, ventura:        "d0e7ac6630f18e53f6c2a167eb86116b90f59d1a27c39505e9e28b5b0175bd31"
    sha256 cellar: :any_skip_relocation, monterey:       "d0e7ac6630f18e53f6c2a167eb86116b90f59d1a27c39505e9e28b5b0175bd31"
    sha256 cellar: :any_skip_relocation, big_sur:        "d0e7ac6630f18e53f6c2a167eb86116b90f59d1a27c39505e9e28b5b0175bd31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2da1f663a8c7af56ce298e649ffe218d5cbb44e556f61e55929e3c51098eb03"
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