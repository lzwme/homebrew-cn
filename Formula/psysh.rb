class Psysh < Formula
  desc "Runtime developer console, interactive debugger and REPL for PHP"
  homepage "https://psysh.org/"
  url "https://ghproxy.com/https://github.com/bobthecow/psysh/releases/download/v0.11.13/psysh-v0.11.13.tar.gz"
  sha256 "67233440d885aeafa4685d78d6dc576fa61bbd17613a016f79b0ca1777e930ae"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d89fda5a363e7ccc79934af6af49949f1195d6e2ae40fd4c6514d219dae66550"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d89fda5a363e7ccc79934af6af49949f1195d6e2ae40fd4c6514d219dae66550"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d89fda5a363e7ccc79934af6af49949f1195d6e2ae40fd4c6514d219dae66550"
    sha256 cellar: :any_skip_relocation, ventura:        "ac9f59a4ddcc8cc461855bf105b277b2d2edf5616057e9f2c9844ec170167a4e"
    sha256 cellar: :any_skip_relocation, monterey:       "ac9f59a4ddcc8cc461855bf105b277b2d2edf5616057e9f2c9844ec170167a4e"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac9f59a4ddcc8cc461855bf105b277b2d2edf5616057e9f2c9844ec170167a4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d89fda5a363e7ccc79934af6af49949f1195d6e2ae40fd4c6514d219dae66550"
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