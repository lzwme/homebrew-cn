class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  # github tarball has issue, https://github.com/carthage-software/mago/issues/794
  url "https://static.crates.io/crates/mago/mago-1.3.0.crate"
  sha256 "a7476d5f4e717a55fae112b282f827a339d1cda1d7d626e9dd1057a1a4e41d1a"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "261779b36a48273d0cd2fc3b847e3e60b3bbba61f72bc38785f02dcc9a5e91b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4668329ea76fe457de2fb8ee00466d0f742c28f18962281fdfa864c8b3973c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b292431ebe87d352055f937890109f7d4cb4cfdb61dde36f9e82524c1ce3e890"
    sha256 cellar: :any_skip_relocation, sonoma:        "38ce95683185dfdbef5b3389537e9c0a52e9e163c51c9b3f42fddf2a6508d834"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "689fc267163082a0d87778855d27c1a329156f87c963aa0202e0ded1d51eea07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c09b8d16f995769a5941814ffbaa616b5a4d4f590147bac7bd7171474fd41e7"
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