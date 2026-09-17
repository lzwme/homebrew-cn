class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://ghfast.top/https://github.com/carthage-software/mago/releases/download/1.49.0/source-code.tar.gz"
  sha256 "934e540c9d2dc4c654df64d3cf7d32aa4a95c3ac612fc37184a9538ccea655c9"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e49562c80f3c22bc76d96644c399b76bfc196ab689db564993a386a663f8a9dc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6d14a6d5c8bc543f53da34a717b76d5a0fa243f6323abb1f8add6d624dcc3ab9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e2abf4c06f0caf2d7ae7d359241da13c8ce1fe87e7e40aa77b0ff33afe75308e"
    sha256 cellar: :any,                 arm64_linux:       "94342c5e38b5284701f0ad7619b46464940dd8c5598797c16efd2161e5934b2f"
    sha256 cellar: :any,                 x86_64_linux:      "42c4aea269008c073db2aa272582fcceccad4b809ce6049b3b25a9d99e9cfda1"
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