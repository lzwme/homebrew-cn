class Psysh < Formula
  desc "Runtime developer console, interactive debugger and REPL for PHP"
  homepage "https://psysh.org/"
  url "https://ghfast.top/https://github.com/bobthecow/psysh/releases/download/v0.12.13/psysh-v0.12.13.tar.gz"
  sha256 "7f77c0c0223199d11ab1fb9e073e6c090b3f65c625f642535956e26ba91ec060"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "17cc035ebb60e336db9d9677e51bf8a6f6239c2cf689d30f0952a0ea1069e15e"
  end

  depends_on "php"

  def install
    bin.install "psysh" => "psysh"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/psysh --version")

    (testpath/"src/hello.php").write <<~PHP
      <?php echo 'hello brew';
    PHP

    assert_match "hello brew", shell_output("#{bin}/psysh -n src/hello.php")
  end
end