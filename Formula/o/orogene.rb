class Orogene < Formula
  desc "`node_modules/` package manager and utility toolkit"
  homepage "https://orogene.dev"
  url "https://ghproxy.com/https://github.com/orogene/orogene/archive/refs/tags/v0.3.33.tar.gz"
  sha256 "7f2048f146a968639237ce997254494d677daa31958e92ecc3832fcc98fdae87"
  license "Apache-2.0"
  head "https://github.com/orogene/orogene.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a6d936f7d19b198941307a214b54093fd183e4f5e6353be3a24670b85d79aa9e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0c4d546cdcbe78d0a65294bfa6ee7de6f69b4bc5cad394635fbd15c3b986c74f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f56a9497948718778346597eb2049641d751e83063c10a3afb7276d28cfba64"
    sha256 cellar: :any_skip_relocation, sonoma:         "c2c9e333a74f0f8045d7caefabbfa4de073bb7613c952a80129b997a74fd1056"
    sha256 cellar: :any_skip_relocation, ventura:        "73686e176d83e5e75d9121f0736dedf294ddb6f51a6270843b637a1333f0f4cd"
    sha256 cellar: :any_skip_relocation, monterey:       "3498e0466e8b1b74cd5fd1781b89f0da252ed354e5103b05a6ccb2fbb61e1d04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e21d60bbe5eaa0458e2cda651fa9a64d700c333ad6b11fe9332cb44bace16203"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oro --version")
    system "#{bin}/oro", "ping"
  end
end