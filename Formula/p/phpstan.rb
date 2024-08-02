class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:github.comphpstanphpstan"
  url "https:github.comphpstanphpstanreleasesdownload1.11.9phpstan.phar"
  sha256 "9557c6485c751070ef4061f7f3540371e0bd1e5be9085241dab1168961b75b2b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d5bd4a4dc22e81104766ffd11d9c244d3a91497a5c4683ae6a70b2ab865390a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5bd4a4dc22e81104766ffd11d9c244d3a91497a5c4683ae6a70b2ab865390a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5bd4a4dc22e81104766ffd11d9c244d3a91497a5c4683ae6a70b2ab865390a4"
    sha256 cellar: :any_skip_relocation, sonoma:         "1c491ebfa96e234d0828c2b5bfec18f6c11bf0898dbb139764fac553aa27e734"
    sha256 cellar: :any_skip_relocation, ventura:        "1c491ebfa96e234d0828c2b5bfec18f6c11bf0898dbb139764fac553aa27e734"
    sha256 cellar: :any_skip_relocation, monterey:       "1c491ebfa96e234d0828c2b5bfec18f6c11bf0898dbb139764fac553aa27e734"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e81f2d55f4706b3241332916f39693c7ef69bb4060bdef8b53f4b2a992dcc44"
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