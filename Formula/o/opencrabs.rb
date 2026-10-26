class Opencrabs < Formula
  desc "Autonomous, self-improving AI agent in a single Rust binary"
  homepage "https://opencrabs.com"
  url "https://ghfast.top/https://github.com/opencrabs/opencrabs/archive/refs/tags/v0.5.14.tar.gz"
  sha256 "002b391b62218602eb8b58e42fa233ebc2c249822f4bfd0e5833b767142541bc"
  license "MIT"
  head "https://github.com/opencrabs/opencrabs.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "89094ed45b8e4c1c13b4995a6864802c690387da607c193ee4a4f019aa3795ba"
    sha256 cellar: :any, arm64_tahoe:       "3a3fff104dd42d7bfdf26b9b1a35ea5cf39b0c9044b25a0fd7341e032dcbf30e"
    sha256 cellar: :any, arm64_sequoia:     "67fad4caf831370046690f6996bc68bfab9a7a8e0e08caebe028d3848e1cdf13"
    sha256 cellar: :any, arm64_linux:       "c488f611a676fd8cbd4c235bcc38591c9640dbd6ce275170e192fbbd4f1cf656"
    sha256 cellar: :any, x86_64_linux:      "3ce66a6fce7fc712dd596b5e5e016714604716b3310a2ed13f1819249cd54009"
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