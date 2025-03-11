class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https:github.comcarthage-softwaremago"
  url "https:github.comcarthage-softwaremagoarchiverefstags0.19.3.tar.gz"
  sha256 "7905f406afafcbfd735f2c13043b8fb2326e983b176655886b4d159864d18f73"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "471cfcaedc6df31b391b9b0f526944fb7c985d86f8f2d8ea933c99e99e678fc6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "446cfa457e85c05426c251e32d2b38721d53c3c8a858eb7b19a82ef15515d1a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e4eca1999e726af226ca24a292f287cef4417d69ccb6a7086b622e4b476d9b5d"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b6e7924777d73e3b7c895cbaa3124442ca18e2ea01176ff047e5f1872bb6e63"
    sha256 cellar: :any_skip_relocation, ventura:       "a689b03df9ce75c7cc413f8ec670987833f31f78676261344e258ca8a33c203d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b89054f90b6272d30cdb3be344b0a5fcb4f0efa8ea31b9956eda59dfe5538a62"
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