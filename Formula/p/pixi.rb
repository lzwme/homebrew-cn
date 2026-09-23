class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://ghfast.top/https://github.com/prefix-dev/pixi/archive/refs/tags/v0.81.0.tar.gz"
  sha256 "6de3f263642615b772400140562ca0a79db2ef489df2efd2499611225481ac24"
  license "BSD-3-Clause"
  head "https://github.com/prefix-dev/pixi.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7fc9bd2b041f97bd81cb632d5a44d105f2988bd60544893a63d8a610764e9f21"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "260119450320fd5a00805faafecf1d90c28826aeeeaf8fc2c42f1829b4e166d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e767b7c79bac55d87a965db688bb11df035880f4b5afa4b47457194d49de2fd4"
    sha256 cellar: :any,                 arm64_linux:       "67cb9ec079fe989d0dc6e8762c7ae5eef58ec63585f27e6ad6f771d0e347daf3"
    sha256 cellar: :any,                 x86_64_linux:      "f3e26e64998ebf2c7532f4cbcdf831d17a57871f9a5b79e00423fa304248db0d"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@4"
    depends_on "xz" # for liblzma
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["PIXI_VERSION"] = Utils.safe_popen_read("git", "describe", "--tags").chomp.delete_prefix("v") if build.head?

    ENV["PIXI_SELF_UPDATE_DISABLED_MESSAGE"] = <<~EOS
      `self-update` has been disabled for this build.
      Run `brew upgrade pixi` instead.
    EOS
    system "cargo", "install", *std_cargo_args(path: "crates/pixi")

    generate_completions_from_executable(bin/"pixi", "completion", "-s")
  end

  test do
    ENV["PIXI_HOME"] = testpath

    assert_equal "pixi #{version}", shell_output("#{bin}/pixi --version").strip

    system bin/"pixi", "init"
    assert_path_exists testpath/"pixi.toml"
  end
end