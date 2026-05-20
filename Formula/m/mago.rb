class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://ghfast.top/https://github.com/carthage-software/mago/releases/download/1.28.0/source-code.tar.gz"
  sha256 "27437b27e96a31f65d2b4fb515427aa8cc4852388729df61ac147d1a7afae111"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd716f8053529e979b430adf721c440ad57260907da9d06fa650ae62b56761f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8666d7c2b0d430877756cd1dd0a8757c7bd01ddfd03d66d034f86916dcb12eb1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0ec9f2e8a79e7653df52fa4fee3038d8204683ad77e7e175a1fceb4ec21c536"
    sha256 cellar: :any_skip_relocation, sonoma:        "b886820b7667b1f4aaba10acc0f4f8c363cdbc6c2be427f52ef81c0e39435182"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c78e541361ec612a815e2d859283dc24ddc64816f97c745893e92eefb79b53c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57cae74934e1612970ef5086d8b23327749576f254b5982835d79f440bb6ae8f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mago --version")

    (testpath/"example.php").write("<?php echo 'Hello, Mago!';")
    output = shell_output("#{bin}/mago lint . 2>&1")
    assert_match "Missing `declare(strict_types=1);` statement at the beginning of the file", output

    (testpath/"unformatted.php").write("<?php echo 'Unformatted';?>")
    system bin/"mago", "fmt"
    assert_match "<?php echo 'Unformatted';?>", (testpath/"unformatted.php").read
  end
end