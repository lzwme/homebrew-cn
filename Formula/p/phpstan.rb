class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://ghproxy.com/https://github.com/phpstan/phpstan/releases/download/1.10.41/phpstan.phar"
  sha256 "32f1faa376ee49f5670791557f4ddc4268e6d9e7ad9c2631f3966740b8d9936a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c634bb819b4cf0b0b0cef7562ff679dafd2a779ef0397364ee3cfd8e0e361460"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c634bb819b4cf0b0b0cef7562ff679dafd2a779ef0397364ee3cfd8e0e361460"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c634bb819b4cf0b0b0cef7562ff679dafd2a779ef0397364ee3cfd8e0e361460"
    sha256 cellar: :any_skip_relocation, sonoma:         "a544028be75648f135e4a599bc0f4e098837ca648924ac4c4014cf7f45495fdf"
    sha256 cellar: :any_skip_relocation, ventura:        "a544028be75648f135e4a599bc0f4e098837ca648924ac4c4014cf7f45495fdf"
    sha256 cellar: :any_skip_relocation, monterey:       "a544028be75648f135e4a599bc0f4e098837ca648924ac4c4014cf7f45495fdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c634bb819b4cf0b0b0cef7562ff679dafd2a779ef0397364ee3cfd8e0e361460"
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