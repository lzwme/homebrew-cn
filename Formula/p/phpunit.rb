class Phpunit < Formula
  desc "Programmer-oriented testing framework for PHP"
  homepage "https://phpunit.de"
  url "https://phar.phpunit.de/phpunit-11.3.2.phar"
  sha256 "9d3dce5f4cf414255dc6130d0ffa848e79dba5e04834b18cd7a196852598ad03"
  license "BSD-3-Clause"

  livecheck do
    url "https://phar.phpunit.de/phpunit.phar"
    regex(%r{/phpunit[._-]v?(\d+(?:\.\d+)+)\.phar}i)
    strategy :header_match
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "931970bfba3907f67f2044cd63c8d24778cab5a357a068ccdf965e64c6dddf1a"
  end

  depends_on "php" => :test

  def install
    bin.install "phpunit-#{version}.phar" => "phpunit"
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
            private $email;

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

    (testpath/"tests/EmailTest.php").write <<~EOS
      <?php
      declare(strict_types=1);

      use PHPUnit\\Framework\\TestCase;

      final class EmailTest extends TestCase
      {
          public function testCanBeCreatedFromValidEmailAddress(): void
          {
              $this->assertInstanceOf(
                  Email::class,
                  Email::fromString('user@example.com')
              );
          }

          public function testCannotBeCreatedFromInvalidEmailAddress(): void
          {
              $this->expectException(InvalidArgumentException::class);

              Email::fromString('invalid');
          }

          public function testCanBeUsedAsString(): void
          {
              $this->assertEquals(
                  'user@example.com',
                  Email::fromString('user@example.com')
              );
          }
      }

    EOS
    assert_match(/^OK \(3 tests, 3 assertions\)$/,
      shell_output("#{bin}/phpunit --bootstrap src/autoload.php tests/EmailTest.php"))
  end
end