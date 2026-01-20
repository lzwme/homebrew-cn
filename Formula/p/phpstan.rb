class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://ghfast.top/https://github.com/phpstan/phpstan/releases/download/2.1.34/phpstan.phar"
  sha256 "df5a8ea90dccc7abf94fc8807df5ae269ec5d9ff4424509052031bb284bc1add"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a67cf0055e07aa8f9e8f337631ce6c98e6b3461be2b6186052bb2fb7c5b069ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a67cf0055e07aa8f9e8f337631ce6c98e6b3461be2b6186052bb2fb7c5b069ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a67cf0055e07aa8f9e8f337631ce6c98e6b3461be2b6186052bb2fb7c5b069ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a538db7e2226709f20783d1e5b4dc5ba550cd849b28a55c8ff62f142c745f21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a538db7e2226709f20783d1e5b4dc5ba550cd849b28a55c8ff62f142c745f21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a538db7e2226709f20783d1e5b4dc5ba550cd849b28a55c8ff62f142c745f21"
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