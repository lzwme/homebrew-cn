class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://ghproxy.com/https://github.com/phpstan/phpstan/releases/download/1.10.34/phpstan.phar"
  sha256 "0466f72a8419a0bce9564f460a6814aff6293dbec786dd5c005f84fd52a46970"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "955cbc80ecbdf76bec5151971d2ea274d47831f3e7e9dcb3bdbdd6267d970e60"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "955cbc80ecbdf76bec5151971d2ea274d47831f3e7e9dcb3bdbdd6267d970e60"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "955cbc80ecbdf76bec5151971d2ea274d47831f3e7e9dcb3bdbdd6267d970e60"
    sha256 cellar: :any_skip_relocation, ventura:        "7539cd424e012861e5aab07d419a0ae7f54bd49dc03b9a229f22881a5e7dda7f"
    sha256 cellar: :any_skip_relocation, monterey:       "7539cd424e012861e5aab07d419a0ae7f54bd49dc03b9a229f22881a5e7dda7f"
    sha256 cellar: :any_skip_relocation, big_sur:        "7539cd424e012861e5aab07d419a0ae7f54bd49dc03b9a229f22881a5e7dda7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "955cbc80ecbdf76bec5151971d2ea274d47831f3e7e9dcb3bdbdd6267d970e60"
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