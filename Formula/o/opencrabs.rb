class Opencrabs < Formula
  desc "Autonomous, self-improving AI agent in a single Rust binary"
  homepage "https://opencrabs.com"
  url "https://ghfast.top/https://github.com/adolfousier/opencrabs/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "84f014d7dd2f17939489168db15ba2600ffb65e72f056474a6c2b39b24dba661"
  license "MIT"
  head "https://github.com/adolfousier/opencrabs.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0dcecb382085efcb2db1b62c249d2c8e1930503eeffe4e5df3fc60837efdc8aa"
    sha256 cellar: :any, arm64_tahoe:       "c0f8afa8aad8dbbc74fa16ba0336282806f9fc6e868cbc837f3c5199e6392b96"
    sha256 cellar: :any, arm64_sequoia:     "947e5135985b6986f86e44899d4e3e8a56435af1fc0c0ff6c76f7f62b53b385e"
    sha256 cellar: :any, arm64_linux:       "61cb8da2264f1ea3ed8eb79e467317e626be8a28515bb7af1958208e68417ddb"
    sha256 cellar: :any, x86_64_linux:      "7a446e0546236e675079a016b52e7e16aab1f52e7815afe7e93127bfcb978498"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "opus"
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
    # symphonia-adapter-libopus bundles libopus by default
    inreplace "Cargo.toml", /^symphonia-adapter-libopus = \{/, "\\0 default-features = false, "

    # Work around arm64 linux runner crashing from fat LTO
    github_arm64_linux = OS.linux? && Hardware::CPU.arm? &&
                         ENV["HOMEBREW_GITHUB_ACTIONS"].present? &&
                         ENV["GITHUB_ACTIONS_HOMEBREW_SELF_HOSTED"].blank?
    if github_arm64_linux
      ENV.deparallelize
      ENV["CARGO_PROFILE_RELEASE_LTO"] = "thin"
    end

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