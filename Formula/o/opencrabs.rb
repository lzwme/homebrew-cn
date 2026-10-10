class Opencrabs < Formula
  desc "Autonomous, self-improving AI agent in a single Rust binary"
  homepage "https://opencrabs.com"
  url "https://ghfast.top/https://github.com/adolfousier/opencrabs/archive/refs/tags/v0.5.5.tar.gz"
  sha256 "89081771ae72f0dcabb2a91c2788228133503b01496c6e5a1ff43fb0e8fadf33"
  license "MIT"
  head "https://github.com/adolfousier/opencrabs.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "974f0800c1808a878a5de82056cf6827c1a1b001a74a292be780120ca7f2cc3a"
    sha256 cellar: :any, arm64_tahoe:       "6ca48e2ee673f7ce5612ac9629c81cf3dec2f57f1f1c7c3e6af3023060a64de7"
    sha256 cellar: :any, arm64_sequoia:     "b5d7bdd919f7c32c815089c8187995bbefb7aee7d5d97c588654a26b086dee6a"
    sha256 cellar: :any, arm64_linux:       "c7419f1744311d6c6e3d0d7559048b0edc2f4910bdea07091f6251b1dbc15f0a"
    sha256 cellar: :any, x86_64_linux:      "3c27d77cf7d7bec6fbd3b17e6174e4834bc1dd7ea95357be63ce7cbaa5bacc04"
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