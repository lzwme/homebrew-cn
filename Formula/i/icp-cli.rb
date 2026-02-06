class IcpCli < Formula
  desc "Development tool for building and deploying canisters on ICP"
  homepage "https://dfinity.github.io/icp-cli/"
  url "https://ghfast.top/https://github.com/dfinity/icp-cli/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "98e79229b3b89b77aaa6237a5540ca719586e17501c7886dbfd5faf0a32d2364"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "38162080409c67940fcbcd5ed44bf36b3e0c80fc9c5506548323ed73cc9e128f"
    sha256 cellar: :any,                 arm64_sequoia: "03cf035c80f3d8488ebf46dbc56e3861c2e3cf1ebf1fae51152722a801636b83"
    sha256 cellar: :any,                 arm64_sonoma:  "41fbb44b38ae38c3fe55fc14a9b71ed1abd7b48fe90512d0e68865ec130b6aa7"
    sha256 cellar: :any,                 sonoma:        "74fdf71c244ca69247d31a33735b776aeebb9b9dc7dee4ea301750d325fb76a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "071dd13cb61fb4b8f33ed5dc9383e873ab92c5496db841d82faa4d82c1a9d014"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a59c2b898944eeccf14ee21da8d6f45ca2e3d93abde0d080c94936af1820af1"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "dbus"
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "crates/icp-cli")
  end

  test do
    output = shell_output("#{bin}/icp identity new alice --storage plaintext")
    assert_match "Your seed phrase", output
  end
end