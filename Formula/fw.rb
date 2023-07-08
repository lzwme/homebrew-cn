class Fw < Formula
  desc "Workspace productivity booster"
  homepage "https://github.com/brocode/fw"
  url "https://ghproxy.com/https://github.com/brocode/fw/archive/refs/tags/v2.16.1.tar.gz"
  sha256 "2d77ce6673e48dd8f20ee42d8a64a0cbe648d51b837cb930b69c3707718659c2"
  license "WTFPL"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f490215245c841b4ccfa7eb370646e68805ea39150cc532afa60d7fd2d385f8f"
    sha256 cellar: :any,                 arm64_monterey: "624030601c29a9ba5cb367f511e5a97aa22e7b1b6a2001a0d270aa0591b7cf95"
    sha256 cellar: :any,                 arm64_big_sur:  "b42ebd783c65e67bdcde6a75290b3a1a5a7e524233e68c159593ee49d97330bf"
    sha256 cellar: :any,                 ventura:        "4e4be06e0dcdd98cc129f39ef34f412f281a7c0789952277f03dbe9a2b4b4776"
    sha256 cellar: :any,                 monterey:       "3c8a65fb6b409756fcf593bc5f7159c816234710c9bee001b6d2566b814a7e9b"
    sha256 cellar: :any,                 big_sur:        "1ae14483fb0a840ce08643f5907030b6d6bf4c443e74e9838aa967a9e2b7c6b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "822b5e2fe18cfe7402dad4c25305d1994e83a5e98ba6a5ede0b289d436039128"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  resource "fw.1" do
    url "https://ghproxy.com/https://github.com/brocode/fw/releases/download/v2.16.1/fw.1"
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