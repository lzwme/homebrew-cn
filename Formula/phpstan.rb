class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://ghproxy.com/https://github.com/phpstan/phpstan/releases/download/1.10.9/phpstan.phar"
  sha256 "6452ddd57d43af30c45071000ede7461b6597bbc013e58c005ca36fc88a6b170"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e210503c126cd9a23a137a352203f85fb09a760c8d651956a2102ed29c4af7ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e210503c126cd9a23a137a352203f85fb09a760c8d651956a2102ed29c4af7ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e210503c126cd9a23a137a352203f85fb09a760c8d651956a2102ed29c4af7ed"
    sha256 cellar: :any_skip_relocation, ventura:        "62259c39b9d89485fc19d4a0d2e49cebbfc39151309d145fac0601cb9927ce18"
    sha256 cellar: :any_skip_relocation, monterey:       "62259c39b9d89485fc19d4a0d2e49cebbfc39151309d145fac0601cb9927ce18"
    sha256 cellar: :any_skip_relocation, big_sur:        "62259c39b9d89485fc19d4a0d2e49cebbfc39151309d145fac0601cb9927ce18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e210503c126cd9a23a137a352203f85fb09a760c8d651956a2102ed29c4af7ed"
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