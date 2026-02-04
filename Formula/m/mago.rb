class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  # github tarball has issue, https://github.com/carthage-software/mago/issues/794
  url "https://static.crates.io/crates/mago/mago-1.4.1.crate"
  sha256 "0426dcce92d9741ea0ad873248ada2b130b39fe453b7e23bd2b2bf562395e144"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c3e0d6403cf63a1c1be6e8e8690da91bef59703894c8984337828472da52ecec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eec5d5486333901f8a9afdf950d3c6c4f313673be0aa44d9650ca95578271f84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f10853e99c2f040d7b4432dbaeb3e9d36c6000328c8eab85f240f948d2d19f35"
    sha256 cellar: :any_skip_relocation, sonoma:        "aadc00851f8f878646a712b28e801207cb0ab2911505d534aad5f4802a6b8dee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f6aa4de4d4c95b6551b84646adc55463027f05473d17412809fb28f8936b319"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d5a0087d6a522f93851b349ac25a7dcb37abfd9e4d9e88375d233c3cabc7a7d"
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