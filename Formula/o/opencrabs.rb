class Opencrabs < Formula
  desc "Autonomous, self-improving AI agent in a single Rust binary"
  homepage "https://opencrabs.com"
  url "https://ghfast.top/https://github.com/opencrabs/opencrabs/archive/refs/tags/v0.5.12.tar.gz"
  sha256 "6a2a9d7500eaa943be1212a0abdf9ff1ce85d21b978aa3c1171f67777b531316"
  license "MIT"
  head "https://github.com/opencrabs/opencrabs.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6e8c0bfcb792c3f0bcc85a635f86624604e7c15d6334a558672835228b94250c"
    sha256 cellar: :any, arm64_tahoe:       "aa3e7279413207cc2087f5d5395112805c428cdd1014e5864bdbe16ffe510442"
    sha256 cellar: :any, arm64_sequoia:     "b8a57242f8175388bfc40fefd3f626fc9bf4bf32bdfe7dbc0e8ec8e658942b41"
    sha256 cellar: :any, arm64_linux:       "b47319823cf1b8645c29b1e7174a63d4a51c58aad1106c1f2afd8617241d7b07"
    sha256 cellar: :any, x86_64_linux:      "b3264c1f21452304ec6476e8f0b1ad102f6337bfded94b9745e10b88fb9b51fc"
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
    assert_match "[database]", config.read

    assert_match "Database:", shell_output("#{bin}/opencrabs config")
  end
end