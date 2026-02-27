class Ord < Formula
  desc "Index, block explorer, and command-line wallet"
  homepage "https://ordinals.com/"
  url "https://ghfast.top/https://github.com/ordinals/ord/archive/refs/tags/0.26.0.tar.gz"
  sha256 "6c955dfb1b67895670467cf5d40f67458a09e22e98a6c372f5be29c3dad0c6ea"
  license "CC0-1.0"
  head "https://github.com/ordinals/ord.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d9243b7e1b58214843a049eb7c7b9d2a5e72ef5f20fc2f78466554cab77b4618"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0605f2c3bf213d936cc5a1726891710f2fcd4315e49cdac487796fff26468299"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "119bbad4f0686966f29ba3a8ce187f81f36083ca8013ddbe20023ccb73509c6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "1cf494361600f3aabb1ee8c3c6ce84a4f552517ed98747c0dc496f4f3a04f44d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98cc6d078045f424ad899e8c5b23be08c4aeeaadf1e1ca4685862cb47cd14927"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57e79a1f7c83a91da7d10b137b7ea9ba963d3fb2d66704649b40c962747f8269"
  end

  depends_on "pkgconf" => :build
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
    output = shell_output("#{bin}/ord list xx:xx 2>&1", 2)
    assert_match "invalid value 'xx:xx' for '<OUTPOINT>': error parsing TXID", output

    assert_match "ord #{version}", shell_output("#{bin}/ord --version")
  end
end