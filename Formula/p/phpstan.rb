class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://ghfast.top/https://github.com/phpstan/phpstan/releases/download/2.1.37/phpstan.phar"
  sha256 "98c823d461b0533a0afc0b1cc8ce8af74b1ba9a26f993014d31d1f4cc022405d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b9fe3087f3f60238ec5233d09f3b583187542d79e024ca9f0e585337c842d43"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b9fe3087f3f60238ec5233d09f3b583187542d79e024ca9f0e585337c842d43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b9fe3087f3f60238ec5233d09f3b583187542d79e024ca9f0e585337c842d43"
    sha256 cellar: :any_skip_relocation, sonoma:        "56f50b96c83374289c4d9645ad0c8ac4f2b9eb5aa485c267f37d0dfbe2fe04ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56f50b96c83374289c4d9645ad0c8ac4f2b9eb5aa485c267f37d0dfbe2fe04ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56f50b96c83374289c4d9645ad0c8ac4f2b9eb5aa485c267f37d0dfbe2fe04ae"
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
    (testpath/"src/autoload.php").write <<~PHP
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
    PHP

    (testpath/"src/Email.php").write <<~PHP
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
    PHP
    assert_match(/^\n \[OK\] No errors/,
      shell_output("#{bin}/phpstan analyse --level max --autoload-file src/autoload.php src/Email.php"))
  end
end