class IcpCli < Formula
  desc "Development tool for building and deploying canisters on ICP"
  homepage "https://dfinity.github.io/icp-cli/"
  url "https://ghfast.top/https://github.com/dfinity/icp-cli/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "6bb4013895e077ad0a51efd8e9639bd82d4c9d364f27169a7df17fda4ba6a709"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "7c7d5ce1d150a1bdd6991273a1a8be1e87e7cb47b010856f0e9dd315dfe33e5a"
    sha256 cellar: :any, arm64_tahoe:       "2cb84025f91de9b43b7b77bb4c841c5f1df8f757c1dcbe59421c3742a7074fc4"
    sha256 cellar: :any, arm64_sequoia:     "32f403e53717b1cacd42d7f48da6063ef4a050b2c3dd6a50e432dd426cf8c4a7"
    sha256 cellar: :any, arm64_linux:       "e5ed2ced0e09ec16e3793a868f198c70af9ac3aaa607fce8bf0ff455aa4f51bd"
    sha256 cellar: :any, x86_64_linux:      "f02b2dce4bbb05b43c8547739a7537be2836e946acc6febf7b837927c678e4d9"
  end

  depends_on "lld" => :build # for `wasm-ld`
  depends_on "rust" => :build
  depends_on "rust-wasm" => :build
  depends_on "ic-wasm"
  depends_on "openssl@4"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "dbus"
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["ICP_CLI_BUILD_DIST"] = "homebrew-core"
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")
    ENV["CARGO_TARGET_WASM32_UNKNOWN_UNKNOWN_LINKER"] = "wasm-ld"
    ENV.append_to_rustflags "--sysroot #{HOMEBREW_PREFIX}"

    system "cargo", "install", *std_cargo_args(path: "crates/icp-cli")
    generate_completions_from_executable(bin/"icp", shell_parameter_format: :clap)
  end

  test do
    output = shell_output("#{bin}/icp identity new alice --storage plaintext")
    assert_match "Your seed phrase", output
  end
end