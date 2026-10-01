class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https://github.com/sysid/bkmr"
  url "https://ghfast.top/https://github.com/sysid/bkmr/archive/refs/tags/v7.6.11.tar.gz"
  sha256 "2933e81544fb35b7e31e9649ecd98eee1e6ad8bda99bd2baadbe5444a8a120a5"
  license "BSD-3-Clause"
  head "https://github.com/sysid/bkmr.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "310a542e180a71519859d65d758492a546419ddeb48a932b8590f5df5fc5d425"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6b3e067878205e1990f4200fd6ddb07a993d57b0785ebcdd3670341ca5fdfdab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "58b99e8953c0f0e580e7b85bbd5fc7e864a962340b0869052ad20b3c4a78bbb5"
    sha256 cellar: :any,                 arm64_linux:       "61af274f2e3dc793fa277a994654d0d785bfe982053e553153c4e2354c78f22d"
    sha256 cellar: :any,                 x86_64_linux:      "df51fd7d34bd6cd8d19c1d8225cdd4b605b78259f9920468f95f1ec54be420a2"
  end

  depends_on "rust" => :build
  depends_on "onnxruntime"

  uses_from_macos "python"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args, "--manifest-path", "bkmr/Cargo.toml"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://docs.rs/openssl/latest/openssl/#manual
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

    # Add Homebrew lib to rpath so dlopen("libonnxruntime.dylib") finds it at runtime
    ENV.append_to_rustflags "-C link-args=-Wl,-rpath,#{rpath(target: formula_opt_lib("onnxruntime"))}"

    cd "bkmr" do
      system "cargo", "install", "--no-default-features", *std_cargo_args(features: "system-ort")
    end

    generate_completions_from_executable(bin/"bkmr", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bkmr --version")

    expected_output = "The configured database does not exist"
    assert_match expected_output, shell_output("#{bin}/bkmr info 2>&1", 1)
  end
end