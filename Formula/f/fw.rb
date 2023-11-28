class Fw < Formula
  desc "Workspace productivity booster"
  homepage "https://github.com/brocode/fw"
  url "https://ghproxy.com/https://github.com/brocode/fw/archive/refs/tags/v2.19.0.tar.gz"
  sha256 "4daae47d2398aa0d5269baa6b416ddd2c58c9bc47c0238884392e765d4fed0b0"
  license "WTFPL"

  # This repository also contains version tags for other tools (e.g., `v4.4.0`
  # is an `fblog` tag), so we can't reliably determine which tags are for `fw`.
  # Upstream only creates GitHub releases from `fw` tags, so we have to check
  # releases instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "517db82c11621c1a7a6deaf84a70dbe5af3aa5f18f25eb016144c71c55568078"
    sha256 cellar: :any,                 arm64_ventura:  "e4d3e49981925697b3c1db9ca7271412fa4c941ce539806e4d7edf3d01ba593d"
    sha256 cellar: :any,                 arm64_monterey: "878aed5e61a87a303426da0b4fcd0c994ba5c07d2f1f27758c8657eff8acc868"
    sha256 cellar: :any,                 sonoma:         "c25a85624eef4019aaca0ae699303b027fbee241f31c639ffad18384a4a468ef"
    sha256 cellar: :any,                 ventura:        "6e8b8c6b0833784b82a8857908157ae0e6f3dc80ac01dd9877698f74def6e8bb"
    sha256 cellar: :any,                 monterey:       "c6f95622215d73adc939e324798a8aba4ddfe3196af076c54e61ec4f7418bc91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69646167a5cfb7a2f9af407c4bb56931468757969f934eb5c7061057fb6dda56"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  resource "fw.1" do
    url "https://ghproxy.com/https://github.com/brocode/fw/releases/download/v2.19.0/fw.1"
    sha256 "b19e2ccb837e4210d7ee8bb7a33b7c967a5734e52c6d050cc716490cac061470"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
    man1.install resource("fw.1")
  end

  test do
    assert_match "Synchronizing everything", shell_output("#{bin}/fw sync 2>&1", 1)
    assert_match "fw #{version}", shell_output("#{bin}/fw --version")
  end
end