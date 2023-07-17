class Psysh < Formula
  desc "Runtime developer console, interactive debugger and REPL for PHP"
  homepage "https://psysh.org/"
  url "https://ghproxy.com/https://github.com/bobthecow/psysh/releases/download/v0.11.19/psysh-v0.11.19.tar.gz"
  sha256 "48613e1b2507315ea0ce4646c1fed30e70c106751e2c18254b01b1ffe6885a4e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d0cca835d8312319bbf2f627f80929026d62154bc5c4bcc50f08ef87328fbe70"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0cca835d8312319bbf2f627f80929026d62154bc5c4bcc50f08ef87328fbe70"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d0cca835d8312319bbf2f627f80929026d62154bc5c4bcc50f08ef87328fbe70"
    sha256 cellar: :any_skip_relocation, ventura:        "a4f71d81f2bc4385fffa2596c7e9c538b1b1bed201e8d3ac664e9b8f7c9d1773"
    sha256 cellar: :any_skip_relocation, monterey:       "a4f71d81f2bc4385fffa2596c7e9c538b1b1bed201e8d3ac664e9b8f7c9d1773"
    sha256 cellar: :any_skip_relocation, big_sur:        "a4f71d81f2bc4385fffa2596c7e9c538b1b1bed201e8d3ac664e9b8f7c9d1773"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0cca835d8312319bbf2f627f80929026d62154bc5c4bcc50f08ef87328fbe70"
  end

  depends_on "php"

  def install
    bin.install "psysh" => "psysh"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/psysh --version")

    (testpath/"src/hello.php").write <<~EOS
      <?php echo 'hello brew';
    EOS

    assert_match "hello brew", shell_output("#{bin}/psysh -n src/hello.php")
  end
end