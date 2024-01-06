class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:github.comphpstanphpstan"
  url "https:github.comphpstanphpstanreleasesdownload1.10.54phpstan.phar"
  sha256 "4c76016cf3a732b931656acbc1c89cf1a77b51dac3a6668eb94988921a5c14e9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "845ead50e70fa056b6daca7ae64f007078fc0fd7d46948d1c21da5dd5888aa87"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "845ead50e70fa056b6daca7ae64f007078fc0fd7d46948d1c21da5dd5888aa87"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "845ead50e70fa056b6daca7ae64f007078fc0fd7d46948d1c21da5dd5888aa87"
    sha256 cellar: :any_skip_relocation, sonoma:         "55b39e9e4420af03f018b999914c09308e49c8692934b76424b95399575a96a7"
    sha256 cellar: :any_skip_relocation, ventura:        "55b39e9e4420af03f018b999914c09308e49c8692934b76424b95399575a96a7"
    sha256 cellar: :any_skip_relocation, monterey:       "55b39e9e4420af03f018b999914c09308e49c8692934b76424b95399575a96a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "845ead50e70fa056b6daca7ae64f007078fc0fd7d46948d1c21da5dd5888aa87"
  end

  depends_on "php" => :test

  # Keg-relocation breaks the formula when it replaces `usrlocal` with a non-default prefix
  on_macos do
    on_intel do
      pour_bottle? only_if: :default_prefix
    end
  end

  def install
    bin.install "phpstan.phar" => "phpstan"
  end

  test do
    (testpath"srcautoload.php").write <<~EOS
      <?php
      spl_autoload_register(
          function($class) {
              static $classes = null;
              if ($classes === null) {
                  $classes = array(
                      'email' => 'Email.php'
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

    (testpath"srcEmail.php").write <<~EOS
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
    assert_match(^\n \[OK\] No errors,
      shell_output("#{bin}phpstan analyse --level max --autoload-file srcautoload.php srcEmail.php"))
  end
end