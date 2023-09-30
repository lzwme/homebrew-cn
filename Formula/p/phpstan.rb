class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://ghproxy.com/https://github.com/phpstan/phpstan/releases/download/1.10.36/phpstan.phar"
  sha256 "a51740b398fab6062868b0da2552df62261401ed243a468e1a4ce4ae0b0fd767"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "60e7a56964c90ceff62a195f736be73e1b75ff33da36f10eddec4dfc76738c3a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "60e7a56964c90ceff62a195f736be73e1b75ff33da36f10eddec4dfc76738c3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60e7a56964c90ceff62a195f736be73e1b75ff33da36f10eddec4dfc76738c3a"
    sha256 cellar: :any_skip_relocation, sonoma:         "1dad543112fb38c77c2a83730fac568b129ff6cf01cfb8e8f2bdeff5f971560f"
    sha256 cellar: :any_skip_relocation, ventura:        "1dad543112fb38c77c2a83730fac568b129ff6cf01cfb8e8f2bdeff5f971560f"
    sha256 cellar: :any_skip_relocation, monterey:       "1dad543112fb38c77c2a83730fac568b129ff6cf01cfb8e8f2bdeff5f971560f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60e7a56964c90ceff62a195f736be73e1b75ff33da36f10eddec4dfc76738c3a"
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