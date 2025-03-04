class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https:github.comcarthage-softwaremago"
  url "https:github.comcarthage-softwaremagoarchiverefstags0.15.0.tar.gz"
  sha256 "746e1c52cfde6cb1c68d01d78731cac8d149d6ec1cae65b7fe5f61c680a9e0cd"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "757d42127ffad379d9a9884515cd50e46fe4dbff89efc84b5d510feb1c260571"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "970b1ac03615bb87d897d6d3bd18e4912aba47d1567c2d056f916a69a0afb9d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3d8493e24976dccb64e6da50c91d93f17ea072be67ecccf91e071f2347b3579c"
    sha256 cellar: :any_skip_relocation, sonoma:        "96b69f185e7d16c2fc8f14f2c82348f5459545213f4d0880329da25c8bbd72e8"
    sha256 cellar: :any_skip_relocation, ventura:       "1b4e17f75a919bf878e3e0ed7d659c5ef5a97c491cd4f9024ad2b2d77be974b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b8208119b1ece9d702bbde559a49374f47f619171e0f9a50c3b137fb9c9538e"
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