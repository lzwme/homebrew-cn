class Opencrabs < Formula
  desc "Autonomous, self-improving AI agent in a single Rust binary"
  homepage "https://opencrabs.com"
  url "https://ghfast.top/https://github.com/adolfousier/opencrabs/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "90de8e6eb09933296f42af44a0779233e86668391aaba92adcc984777008574b"
  license "MIT"
  head "https://github.com/adolfousier/opencrabs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e59ee163bdc9b3212e70f8b3523efdbcad77168b0cc932759c2eb4e203cd63ed"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2a80b6135aaefa8ae10dc47b524c68f9e5b246f7f9d1e994a7b80994a47cb0ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0279d63b15bc2416548b5a2fbb4d3b1d5b40927479009c687496be3f45882e65"
    sha256 cellar: :any,                 arm64_linux:       "74ded00066c59a49132004cf2d19691f13c1d4cab3a113b2c888272c0c2f769c"
    sha256 cellar: :any,                 x86_64_linux:      "39cb29dab096086bc72c669845dea160f4242c32eed5d284f7ec96d2e6bbe5c8"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rtk"

  on_linux do
    depends_on "alsa-lib"
    depends_on "openssl@3"
  end

  def install
    ENV["LIBCLANG_PATH"] = formula_opt_lib("llvm").to_s
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version.to_s if OS.mac?

    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"opencrabs", "init"

    config = testpath/".opencrabs/config.toml"
    assert_path_exists config
    assert_match "[provider_registry]", config.read

    assert_match "Database:", shell_output("#{bin}/opencrabs config")
  end
end