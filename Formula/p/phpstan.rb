class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://ghproxy.com/https://github.com/phpstan/phpstan/releases/download/1.10.45/phpstan.phar"
  sha256 "cc8b6963f41564c84de56799b47ea6d1d70f8a65298cff4f3ecf0841e67758fa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0f70da6888b2643ee520ef8224d1af56727de90ff9acf1ed226a3f49043679c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f70da6888b2643ee520ef8224d1af56727de90ff9acf1ed226a3f49043679c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f70da6888b2643ee520ef8224d1af56727de90ff9acf1ed226a3f49043679c4"
    sha256 cellar: :any_skip_relocation, sonoma:         "82962fd6ba482a60819efd2af878b911b6b75eeba89262ee59f07e657d40248c"
    sha256 cellar: :any_skip_relocation, ventura:        "82962fd6ba482a60819efd2af878b911b6b75eeba89262ee59f07e657d40248c"
    sha256 cellar: :any_skip_relocation, monterey:       "82962fd6ba482a60819efd2af878b911b6b75eeba89262ee59f07e657d40248c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f70da6888b2643ee520ef8224d1af56727de90ff9acf1ed226a3f49043679c4"
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