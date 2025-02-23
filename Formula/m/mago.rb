class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https:github.comcarthage-softwaremago"
  url "https:github.comcarthage-softwaremagoarchiverefstags0.11.1.tar.gz"
  sha256 "7c796a47aab2bfd09678bba906ff1447bc1d5040217f34944ee8e4fae634413f"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b57c78677e40a77be948e7268128028d568440f9c701abe4029a63d3bfa1111"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07202dda0c7b8303eed4acf09cf0481b965e9663c09cec0c495938962e3c0ad9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b3ce731d9259cebb4f0c89777411d954826ec7e9d049b13407e192822f823164"
    sha256 cellar: :any_skip_relocation, sonoma:        "13003dd2edefd256dda7267705c1fe04ecf63dae2285f3507ed9b9c10b3027d6"
    sha256 cellar: :any_skip_relocation, ventura:       "8d2397a8d1fba8ebe5a5660fe53dfa4fe47226371c3eb7cda5b4ce8281c6c085"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "258035311f12ea995b52087dc0da923f4908fad7b643a5eb746f75e3ace120bb"
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