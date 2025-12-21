class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  # github tarball has issue, https://github.com/carthage-software/mago/issues/794
  url "https://static.crates.io/crates/mago/mago-1.0.1.crate"
  sha256 "ae006028fd4ae826913f8b2b960dec49ca5985284a51d1627ba22c04ebacca94"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f22ede042ac66f66fac6c9a55fed2f626067707381ae0127d7cf14cdf25127b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56914f5f76123a13ae1f56f55940f253afaa4d0d5a5b10ba37e3e9747b8b1c2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "865c22bdbb83630663afdaae7559dd805b4ecce78c7d334144c845539fc9f058"
    sha256 cellar: :any_skip_relocation, sonoma:        "ddb017a8a2a53679dfd8c63becf6a659cb5d62c7637ce19346869325f369a5f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7920770657439f0bd639c0766c02426b29cdfda0535c61eea29e96361533ed5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfc3f9226896fca55f185aaf76b69f08d14751491ccc4eab962f71899416b039"
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
    assert_match " Missing `declare(strict_types=1);` statement at the beginning of the file", output

    (testpath/"unformatted.php").write("<?php echo 'Unformatted';?>")
    system bin/"mago", "fmt"
    assert_match "<?php echo 'Unformatted';?>", (testpath/"unformatted.php").read
  end
end