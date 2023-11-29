class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://ghproxy.com/https://github.com/phpstan/phpstan/releases/download/1.10.46/phpstan.phar"
  sha256 "69d352ca3c9fa462647f0a66b886379a9e83a23c5e3d5cfd487edf615e245072"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f888fbae81ca99d33644d178903c30ce1ae6f2665b5abc39f576d360cb50b0aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f888fbae81ca99d33644d178903c30ce1ae6f2665b5abc39f576d360cb50b0aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f888fbae81ca99d33644d178903c30ce1ae6f2665b5abc39f576d360cb50b0aa"
    sha256 cellar: :any_skip_relocation, sonoma:         "2b61d3e7f0a13600cda17f4d5ba6eaf65996e8460968635c16e48f56e19216f4"
    sha256 cellar: :any_skip_relocation, ventura:        "2b61d3e7f0a13600cda17f4d5ba6eaf65996e8460968635c16e48f56e19216f4"
    sha256 cellar: :any_skip_relocation, monterey:       "2b61d3e7f0a13600cda17f4d5ba6eaf65996e8460968635c16e48f56e19216f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f888fbae81ca99d33644d178903c30ce1ae6f2665b5abc39f576d360cb50b0aa"
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