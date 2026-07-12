class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https://github.com/sysid/bkmr"
  url "https://ghfast.top/https://github.com/sysid/bkmr/archive/refs/tags/v7.6.6.tar.gz"
  sha256 "57149e91322da8043a2ded8ef56f8e5f73a953589a09332eb41602f3c9b9d5c6"
  license "BSD-3-Clause"
  head "https://github.com/sysid/bkmr.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2e555f12513f2b3bcbd3a40485734ec1fac91408d51b75076deec58d6d4bf03"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a353b3ce59e0dc1deb07b7ae8b55384c888cba225fb499c0e3f49f9c50c1b26b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d20b8c1f9a3d5d448e83a663834e2817d958becc20b2c3e6cb64999187f85830"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6465282d77af62c14f2ddce38badaed907ffe9c35253124e7fbcbb6407c77d5"
    sha256 cellar: :any,                 arm64_linux:   "fe94c80109106a28b28e74b9f825a95434b0aa7acac525a38a30710c0f0ce106"
    sha256 cellar: :any,                 x86_64_linux:  "6c253698ad77c4d6bc5709eecaf5ef3176a3052bdf6c2f5da9bb8e9a1aca89f8"
  end

  depends_on "rust" => :build
  depends_on "onnxruntime"
  depends_on "openssl@3"

  uses_from_macos "python"

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