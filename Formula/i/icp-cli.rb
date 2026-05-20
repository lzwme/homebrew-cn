class IcpCli < Formula
  desc "Development tool for building and deploying canisters on ICP"
  homepage "https://dfinity.github.io/icp-cli/"
  url "https://ghfast.top/https://github.com/dfinity/icp-cli/archive/refs/tags/v0.2.7.tar.gz"
  sha256 "5c0c8b261d300ae2606f65e5c76a313b466d7081a9dd6034e0add0225633a1bb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a962eec507c6285051440cc5ca614782f5a36420cf23924fba9a594d6e074691"
    sha256 cellar: :any,                 arm64_sequoia: "a8c8720ffb48649e74613a17bffd612c06fdd376be725c6808f28ab7008ea789"
    sha256 cellar: :any,                 arm64_sonoma:  "6c492b8c250e680d8de73ab31f6715156bb4365809a6836348c2928fb80c7aa1"
    sha256 cellar: :any,                 sonoma:        "524823be6045df4eaa92b72c839046fe097d938422efe378a0a20c0f0b5cca7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ff9f4788c987a4095c7efc456157047d30ee52b05ada78a29a7c612ddc1667a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c2359df4966b94a500e85b0ff8690933d40133f379dd9ce81d149415194fa72"
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