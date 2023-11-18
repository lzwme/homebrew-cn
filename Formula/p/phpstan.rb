class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://ghproxy.com/https://github.com/phpstan/phpstan/releases/download/1.10.42/phpstan.phar"
  sha256 "510f7dd77cdf7bee28ee7e8426ca4ddce4ab7123676bbe6bb62533df0639ce37"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2ece9782b5b3fd56b64d8c0a5965e364ef4641f1a910a953209be0019cddfc1f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ece9782b5b3fd56b64d8c0a5965e364ef4641f1a910a953209be0019cddfc1f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ece9782b5b3fd56b64d8c0a5965e364ef4641f1a910a953209be0019cddfc1f"
    sha256 cellar: :any_skip_relocation, sonoma:         "b6cf5b132d2f9d9aff946e4085d3119b0ee773f5dc3ddce6f17b1a1624ea5575"
    sha256 cellar: :any_skip_relocation, ventura:        "b6cf5b132d2f9d9aff946e4085d3119b0ee773f5dc3ddce6f17b1a1624ea5575"
    sha256 cellar: :any_skip_relocation, monterey:       "b6cf5b132d2f9d9aff946e4085d3119b0ee773f5dc3ddce6f17b1a1624ea5575"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ece9782b5b3fd56b64d8c0a5965e364ef4641f1a910a953209be0019cddfc1f"
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