class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https://github.com/sysid/bkmr"
  url "https://ghfast.top/https://github.com/sysid/bkmr/archive/refs/tags/v7.6.8.tar.gz"
  sha256 "1375b234c1e0616846278ebcd32b20bc83b6747470a4d03307f847f0e193b291"
  license "BSD-3-Clause"
  head "https://github.com/sysid/bkmr.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f465d1427881aa51867ee46b5c9e0cc1f1083862596cccae950409eafce3f0ce"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "27e368f514c96fd575aa0b64546225031f0c8557ce6c8453658498b43472e119"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "35b392ae3798a80473332e8e0ff091e00f0df148d468107e5c368db50540d65a"
    sha256 cellar: :any,                 arm64_linux:       "06be3cefc4a602daba09b954055f661a42da803a27b1c208a7dddaf1e4f4ae23"
    sha256 cellar: :any,                 x86_64_linux:      "dbd615567c99ef1008b34b7c98b77c857bf35ce2350f7a6dc55fe65708800759"
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