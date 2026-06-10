class IcpCli < Formula
  desc "Development tool for building and deploying canisters on ICP"
  homepage "https://dfinity.github.io/icp-cli/"
  url "https://ghfast.top/https://github.com/dfinity/icp-cli/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "3845e3449d80e105cff6b48969da70ebecc6c3ae8160c849e1d293ffbc5eb4d2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "35fc42bab1a98ea7954ec720511ef92ab0c9f3621cb6d083f61d081f7223300c"
    sha256 cellar: :any, arm64_sequoia: "825b8101191a18f38c0ded04e6a0866f5bd7640ff167b28c9a1415f1b38a99c7"
    sha256 cellar: :any, arm64_sonoma:  "79e153b6bde0981df2b82b3baf8d838c96643ad986fe4a21d8ff1ab80e8fc7a4"
    sha256 cellar: :any, sonoma:        "cbc78cba9246f5a6dd0f40c13232e30ace042600634ebceaea3bb9e602be335e"
    sha256 cellar: :any, arm64_linux:   "61af590a071f1da0a3378d1b89693cefdcc78da2f82c8f8fa1817f7f4abe4536"
    sha256 cellar: :any, x86_64_linux:  "ef802225ad34006dc9e5556f03ce77b913c85b31a08f7ff6bdc60e0ad3902191"
  end

  depends_on "rust" => :build
  depends_on "ic-wasm"
  depends_on "openssl@4"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "dbus"
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["ICP_CLI_BUILD_DIST"] = "homebrew-core"
    ENV["OPENSSL_DIR"] = Formula["openssl@4"].opt_prefix

    # Skip wasm32-wasip2 test fixture build in icp-sync-plugin (only used in tests)
    # https://github.com/dfinity/icp-cli/issues/543
    inreplace "crates/icp-sync-plugin/build.rs", "build_test_fixture();", ""

    system "cargo", "install", *std_cargo_args(path: "crates/icp-cli")
  end

  test do
    output = shell_output("#{bin}/icp identity new alice --storage plaintext")
    assert_match "Your seed phrase", output
  end
end