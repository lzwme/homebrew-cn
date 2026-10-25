class Opencrabs < Formula
  desc "Autonomous, self-improving AI agent in a single Rust binary"
  homepage "https://opencrabs.com"
  url "https://ghfast.top/https://github.com/opencrabs/opencrabs/archive/refs/tags/v0.5.13.tar.gz"
  sha256 "685d9172ae4d882b4d578ba833cc47f5c17070bc5b9a4877ef6ccab87bc3a5de"
  license "MIT"
  head "https://github.com/opencrabs/opencrabs.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3dd6e0245a0b9c575012268ac0bc256508dcd59deddcdffbfebd737099508454"
    sha256 cellar: :any, arm64_tahoe:       "d4753951586f9586936e699c79c917881e420b1552aafc1b94fcd70895ce3226"
    sha256 cellar: :any, arm64_sequoia:     "be7fc050a67d35af7434a6c9a23e6b131757e42589be4b0143cbb0b3766af5e0"
    sha256 cellar: :any, arm64_linux:       "57f4d45af9ddd099427c8a9feacfaf1d585dd0e245cc9d08452afda63f2a2687"
    sha256 cellar: :any, x86_64_linux:      "f505c0c67c01bbfcac43334d985f30a780ae4e10850e6881e40d1039608c32ef"
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