class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.64.1.tar.gz"
  sha256 "33731567e3aeace859b02334a5a3ff757d9c97646892670def96eff2a8c9cc5f"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "63d13b9b1524fa5daf6d7919bae2955da4788299aad059648a9d25e757d96ee8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0330043b29e00f64ad0e822a88f3df34e2c940c79cabf42f519d817157f75752"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4f3a7209bf2b49824128098cfa1b2cadfb7f29a7f682b8614a1b85918356a91e"
    sha256 cellar: :any,                 arm64_linux:       "6bce362f96ae0eefd726c0ba154153ab892c86b5cfd2c3827cd1bc26e07e5630"
    sha256 cellar: :any,                 x86_64_linux:      "bf721a08b1d524576af09f2428065ad9ed723828013de5111c3cc2257cc2f06b"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railway #{version}", shell_output("#{bin}/railway --version").strip
  end
end