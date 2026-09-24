class Opencrabs < Formula
  desc "Autonomous, self-improving AI agent in a single Rust binary"
  homepage "https://opencrabs.com"
  url "https://ghfast.top/https://github.com/adolfousier/opencrabs/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "1b2ffbf219c4b63108eab557926e116618e34f949dd3ffb39d28d8e3f5190425"
  license "MIT"
  head "https://github.com/adolfousier/opencrabs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "22adbfddcf86c0e64f966cb0a0b71a044c8710506c6e7ddcd156774fb022f5c8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1933ee9476c3ecb3a271d37415cc2c469f6f7c23c07b931c8abf5966654bdcc5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8e278e43bac1ed70190cf64c69273f0388083eabcc11fe53ac94f2fc5ee4760d"
    sha256 cellar: :any,                 arm64_linux:       "e82fad0a191e400a8476a88eb9447ae37ef266358e4e8b6407d0552b77b4258c"
    sha256 cellar: :any,                 x86_64_linux:      "248aa0b2c2145603286eea8089791ff12a1c8c32c901a4c6bec1f317364b2186"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rtk"

  on_linux do
    depends_on "alsa-lib"
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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