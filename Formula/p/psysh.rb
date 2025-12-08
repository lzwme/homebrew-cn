class Psysh < Formula
  desc "Runtime developer console, interactive debugger and REPL for PHP"
  homepage "https://psysh.org/"
  url "https://ghfast.top/https://github.com/bobthecow/psysh/releases/download/v0.12.16/psysh-v0.12.16.tar.gz"
  sha256 "1113adfa64de1a3dea1872add2fd29fd502eca3003b43e61ad9c1f541273f61c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "daaa58e4f1a42578e479d9131e5c7417f72c59414345c929833969d401ac4643"
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