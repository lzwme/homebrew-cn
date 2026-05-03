class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://ghfast.top/https://github.com/carthage-software/mago/releases/download/1.25.2/source-code.tar.gz"
  sha256 "7a4373dd007f0f4eef3cc7b573f569841aca97334c52f07889c7d91b765506d3"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b16058a03bf5bf0cf2222b6260c1e6d489cb51901e26f56e47eaeccada065b7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a81a634d361d9ba4570fbc86eae8b6ea5b54e0799a53af1f6a5e61e0cdd11d9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abbb15e685b97a118fbf27d699a8d43be996a57ca1c433aa5449337bb11a13ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec9de49c17a17f09054d4c60707152ee6765b575d040b66d92eb7162a8be5a07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9439ccc7fddf837185cd7a47c6da0df5103ea9483bfe257720378bcda1cec99f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "133f8d09e4878effe4eb72122cfd84c7de3d676d6980923081945c7a040192ed"
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