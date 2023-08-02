class Fw < Formula
  desc "Workspace productivity booster"
  homepage "https://github.com/brocode/fw"
  url "https://ghproxy.com/https://github.com/brocode/fw/archive/refs/tags/v2.17.0.tar.gz"
  sha256 "0e08a8c02f013df033bad41b19ad772480bee76060b1030a9cec0b81aa7879db"
  license "WTFPL"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "314a3d7a4e1225f96babcc3afd7872e2c5e42e83e81fea1d8abbdad2aa9026eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2c7f6e1cb132ec9290647036e1fdee7e2a55f9d052ff701995ac35fe4e74ed1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d4f436dd01757e5ade390e4e69ba0ce4ebb76b25577b3abdc11ce6e40635b01a"
    sha256 cellar: :any_skip_relocation, ventura:        "37eae05b9104db501610875f8d9054b6dbeda96f2bcbc6084986a18a035a1660"
    sha256 cellar: :any_skip_relocation, monterey:       "c575ba67ca71f53d7bb2f0f73074e9f3d3bcc8950b1bbfffa0908ed98d0f7b54"
    sha256 cellar: :any_skip_relocation, big_sur:        "d2fd6dcb47e50d4fe4b5118aaff5a705bbfd3e724d5aa46a36550af98372c5b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fde468170ff3fbbea281357d46f30067ba8d5d908dd3e1f345b1cef0cca81e74"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  resource "fw.1" do
    url "https://ghproxy.com/https://github.com/brocode/fw/releases/download/v2.17.0/fw.1"
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