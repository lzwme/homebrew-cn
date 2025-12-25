class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  # github tarball has issue, https://github.com/carthage-software/mago/issues/794
  url "https://static.crates.io/crates/mago/mago-1.0.3.crate"
  sha256 "e0ebe2de91614bfa62a09783b666417082bdb0bc57e46ad26aa1b17c21d8eb8d"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f0dfe73abfd264eef3e43a33296abf73dbe222861bd246a71e74d2464d7f9c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f44eeb6c0d733973a5a29b2493a7534a148b80aa35d5e9a77129852bf42863ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e4d54bf41c5d1fe36d8c9f85b3098ba282b3d23c26e1dd73a7d2821740e1568"
    sha256 cellar: :any_skip_relocation, sonoma:        "481baa361c0987554eaf0bfd258d6c2ca0d6780a594a28c242745b1d6152d028"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "756cafaa1886f25c9a10b363a6c2b9dbc5e40e8a6c7bbf38e638ae31bf9d9928"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f75ee8268abb62ae98db3170c50befa670799ab16ca4cc40eb14218d29f9d61"
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