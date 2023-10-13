class Gitoxide < Formula
  desc "Idiomatic, lean, fast & safe pure Rust implementation of Git"
  homepage "https://github.com/Byron/gitoxide"
  url "https://ghproxy.com/https://github.com/Byron/gitoxide/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "70c139c7cef2297a100a4de3b936d402117bb2f87f20f586ae0b83418944fe7c"
  license "Apache-2.0"
  head "https://github.com/Byron/gitoxide.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e30a574534f91bc301cd960a85325725356e9d89628f7293dd7b3e0bae6f6015"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3bd281932144e4dc716b2ac168a517b2ca7bd51741312ab702ff739d7bc523b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2948c8f8589a89265d42012d73d324bd5b1cfba4a62c0db77ebb2be6b224661"
    sha256 cellar: :any_skip_relocation, sonoma:         "9bf521a1b0c69e6bafedff4a51fc754b3750edf0e46fc19acf156d4c77d6fca1"
    sha256 cellar: :any_skip_relocation, ventura:        "c605e4b2f14f48a696693ff5be51df1b6e3d53c7da421afe6d8f64699a201fc0"
    sha256 cellar: :any_skip_relocation, monterey:       "a4ec10791a78ade4c7861cee322b9ec49e28b4c1aa047a9b3613fe512cad8572"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "405e345025cd432bf47fb273b8cabf1c43e4b2d50c4aa89d6b0ed426ca663599"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    # Avoid requiring CMake or building a vendored zlib-ng.
    # Feature array corresponds to the default config (max) sans vendored zlib-ng.
    # See: https://github.com/Byron/gitoxide/blob/b8db2072bb6a5625f37debe9e58d08461ece67dd/Cargo.toml#L88-L89
    features = %w[max-control gix-features/zlib-stock gitoxide-core-blocking-client http-client-curl]
    system "cargo", "install", "--no-default-features", "--features=#{features.join(",")}", *std_cargo_args
  end

  test do
    assert_match "gix", shell_output("#{bin}/gix --version")
    system "git", "init", "test", "--quiet"
    touch "test/file.txt"
    system "git", "-C", "test", "add", "."
    system "git", "-C", "test", "commit", "--message", "initial commit", "--quiet"
    # the gix test output is to stderr so it's redirected to stderr to match
    assert_match "OK", shell_output("#{bin}/gix --repository test verify 2>&1")
    assert_match "gitoxide", shell_output("#{bin}/ein --version")
    assert_match "./test", shell_output("#{bin}/ein tool find")
  end
end