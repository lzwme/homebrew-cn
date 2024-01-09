class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https:github.comphpstanphpstan"
  url "https:github.comphpstanphpstanreleasesdownload1.10.55phpstan.phar"
  sha256 "809b4f20167ee402a176a47d64642aae8e5662fadb18d5d37f2e99c9b2f422d5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b4681922736aba12a7806129a3f87791e52af70547d962d49bad491134c68743"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4681922736aba12a7806129a3f87791e52af70547d962d49bad491134c68743"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4681922736aba12a7806129a3f87791e52af70547d962d49bad491134c68743"
    sha256 cellar: :any_skip_relocation, sonoma:         "9d81d51b5b65a588174079065b0f19cd9a1988ef37ab093e7564c7e1f8d3285a"
    sha256 cellar: :any_skip_relocation, ventura:        "9d81d51b5b65a588174079065b0f19cd9a1988ef37ab093e7564c7e1f8d3285a"
    sha256 cellar: :any_skip_relocation, monterey:       "9d81d51b5b65a588174079065b0f19cd9a1988ef37ab093e7564c7e1f8d3285a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4681922736aba12a7806129a3f87791e52af70547d962d49bad491134c68743"
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