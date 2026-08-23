class Gitoxide < Formula
  desc "Idiomatic, lean, fast & safe pure Rust implementation of Git"
  homepage "https://github.com/GitoxideLabs/gitoxide"
  url "https://ghfast.top/https://github.com/GitoxideLabs/gitoxide/archive/refs/tags/v0.57.0.tar.gz"
  sha256 "a81d98e99f91964f44675a8452ffe01dbbcc061997461ad82421c0cb61beac32"
  license "Apache-2.0"
  head "https://github.com/GitoxideLabs/gitoxide.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05268cbec9c3e71c62c33b879b8e37160d990d24189cc47c2b0e2d02c22f0084"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77ae6b156584fc2feab103ece0f2e2cfb0d6dac5ede316904d313829b44dacd3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b134c1c7ba3d74310ae0cb4d93f562d8dc1e242f1c8a5ba3615b209593245b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c9bc1ef5600f11e473fe9b999aa0cd04b9a5d91b9e889b9441558d564dbe150"
    sha256 cellar: :any,                 arm64_linux:   "8f1df919329ecbb5cb77df030ef29ec7e5bfa19a131425429947a072ff87c9ab"
    sha256 cellar: :any,                 x86_64_linux:  "f68b147e6e08f01d7fd4ede546d2972fe3bbf4e24a570d37c2604544634df263"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  uses_from_macos "curl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    features = %w[max-control gitoxide-core-blocking-client http-client-curl hashes]
    system "cargo", "install", "--no-default-features", *std_cargo_args(features:)
    generate_completions_from_executable(bin/"gix", "completions", "-s")
    generate_completions_from_executable(bin/"ein", "completions", "-s")
  end

  test do
    assert_match "gix", shell_output("#{bin}/gix --version")
    system "git", "init", "test", "--quiet"
    touch "test/file.txt"
    system "git", "-C", "test", "add", "."
    system "git", "-C", "test", "commit", "--message", "initial commit", "--quiet"
    # the gix test output is to stderr so it's redirected to stderr to match
    assert_match "OK", shell_output("#{bin}/gix --repository test verify 2>&1")
    assert_match "ein", shell_output("#{bin}/ein --version")
    assert_match "./test", shell_output("#{bin}/ein tool find")
  end
end