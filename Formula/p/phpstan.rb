class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:github.comphpstanphpstan"
  url "https:github.comphpstanphpstanreleasesdownload1.11.10phpstan.phar"
  sha256 "584479c57eb6dbc0b7dfb00fa08d7a1014e09421951febee65c81de2aa5b5ab2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "363046e476ee6b0e73d7864e0b3d920a0d98cca406f80e13be815307ece19d53"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "363046e476ee6b0e73d7864e0b3d920a0d98cca406f80e13be815307ece19d53"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "363046e476ee6b0e73d7864e0b3d920a0d98cca406f80e13be815307ece19d53"
    sha256 cellar: :any_skip_relocation, sonoma:         "b96c7f1307e12289680c605dd140ce37f78606e68f9e2eabd50602a928263a4e"
    sha256 cellar: :any_skip_relocation, ventura:        "b96c7f1307e12289680c605dd140ce37f78606e68f9e2eabd50602a928263a4e"
    sha256 cellar: :any_skip_relocation, monterey:       "b96c7f1307e12289680c605dd140ce37f78606e68f9e2eabd50602a928263a4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "210f1e8601bf3d17bba5d5b2029acb7cbdf48d4cb9aca2bf73769a34d412797e"
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