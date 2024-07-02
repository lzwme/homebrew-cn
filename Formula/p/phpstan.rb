class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:github.comphpstanphpstan"
  url "https:github.comphpstanphpstanreleasesdownload1.11.6phpstan.phar"
  sha256 "2934a98dac4957a914478e3bcf1d870d8a7d3923effbd07d459501535f3599b7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "11052f77d1b0cc9c0073bf66156d741a44fd929282dbf64204e07b10cfed2e2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11052f77d1b0cc9c0073bf66156d741a44fd929282dbf64204e07b10cfed2e2d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11052f77d1b0cc9c0073bf66156d741a44fd929282dbf64204e07b10cfed2e2d"
    sha256 cellar: :any_skip_relocation, sonoma:         "8f17a02477348bb23c65ba78b2baef30e538ed000bbca9f6cb977004844e6a5e"
    sha256 cellar: :any_skip_relocation, ventura:        "8f17a02477348bb23c65ba78b2baef30e538ed000bbca9f6cb977004844e6a5e"
    sha256 cellar: :any_skip_relocation, monterey:       "8f17a02477348bb23c65ba78b2baef30e538ed000bbca9f6cb977004844e6a5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cde15dc626b4157a08cbf922d39a16e3fc9b986ac9e39868b35feae434b99ea"
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