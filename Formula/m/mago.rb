class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https:github.comcarthage-softwaremago"
  url "https:github.comcarthage-softwaremagoarchiverefstags0.7.0.tar.gz"
  sha256 "148b95922814fbbf2b320eae968d36263e4f022f47b4af7c21e9ac8c2e7ec2b5"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70d2b63b0130aa7736940303e2f1a4dffe35503306c587ae942721a67cdf98e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d13eb088316cbeaf4db4db830d2dc310f8336186160a71e783940570538dcb87"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "17290935825d5be950439281f5727fc79ff585988a7269871e4502f6868a7873"
    sha256 cellar: :any_skip_relocation, sonoma:        "a89f54f35ff49f261f639521ea298697e5d0048d5c02262f5d2cc155ae0555c7"
    sha256 cellar: :any_skip_relocation, ventura:       "d73d528698164ad7893cb891754b93add85037e29f1a895c618e2b3c0e465250"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09ece907009b6cd9f722b8f130ab77bc49432753917ba46d7680a7d8e8b2320f"
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
    assert_match version.to_s, shell_output("#{bin}mago --version")

    (testpath"example.php").write("<?php echo 'Hello, Mago!';")
    output = shell_output("#{bin}mago lint 2>&1")
    assert_match " Missing `declare(strict_types=1);` statement at the beginning of the file", output

    (testpath"unformatted.php").write("<?php echo 'Unformatted';?>")
    system bin"mago", "fmt"
    assert_match "<?php echo 'Unformatted';\n", (testpath"unformatted.php").read
  end
end