class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https://github.com/sysid/bkmr"
  url "https://ghfast.top/https://github.com/sysid/bkmr/archive/refs/tags/v7.7.1.tar.gz"
  sha256 "9aa5b9387ab6e7b96a5777dc868b0bc1742566ed96ac1b0ee910f629e8ded100"
  license "BSD-3-Clause"
  head "https://github.com/sysid/bkmr.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4086326ce45c44916f2daf0785f5a8d549a99899fb811b624122861560bd63b1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c330f0cead178d11afc82159f6b6df508e93fd6d3fdb174625c2540bb55bfaa4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9a9200bc8eebf78e19fc79f0d6a8a4757eae7f01a7dd7ea050880f5578565393"
    sha256 cellar: :any,                 arm64_linux:       "05c544b580f8d5941fdfe3e5fb6c5bbad41e687f6decdcbe56fa3d3184deb0d0"
    sha256 cellar: :any,                 x86_64_linux:      "94cb55e40c0a846d51faba622c523d13655bd4d25071f3d476a607b4d1e277c7"
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