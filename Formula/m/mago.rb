class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://ghfast.top/https://github.com/carthage-software/mago/releases/download/1.21.1/source-code.tar.gz"
  sha256 "a89152945fcace50da3f7f425f34d1a5c9f385a75a20353a1fb32a63d59f90d0"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "155dc6d161674aa2538cde2b38f41fa2d3f874f3ab59bb121e508ae577644da1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1edc49802ba12b902cce7caa29f7dabf6d3354862add88cdb987ab00dcefcd13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d9b9406861ea3085ff7c0afe1a7fedda0eaefc450a11dbcd2a7652fc62de1e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "4280d1f2cc34fd541f238f49e62a442387c8fbb80d2b134b78965088ac356542"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "173e23a945bfa1d0e718385af29c5015b37902811940a828b483b0206d60f71c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00b669b564cb39b5d3817439116b360462e26fe7dc43353ea02e517530652431"
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