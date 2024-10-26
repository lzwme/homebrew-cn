class Gitoxide < Formula
  desc "Idiomatic, lean, fast & safe pure Rust implementation of Git"
  homepage "https:github.comByrongitoxide"
  url "https:github.comByrongitoxidearchiverefstagsv0.38.0.tar.gz"
  sha256 "650a9ecae3953505db59983d10583bb8eb69ce820f794735c0fa8c519ca902b4"
  license "Apache-2.0"
  head "https:github.comByrongitoxide.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3cb0676fe41612dcb88ffca3f6bb3c9fa040524d307fc6e1a92b8dbb02e28e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba6f975848ff1ae513e52b472a71d3e62de5773824763c1b519432ac99be6631"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f7d34119a5b78eed48b09b29470eea253b92ce1168e158c711d25f166528e8c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "d553d6321b325321f2a1989ac1cfb40417df8b714cd4e94dbc02910df2f68032"
    sha256 cellar: :any_skip_relocation, ventura:       "1212d146dc8c9bb8e8f40b85bf3986852b6e7c523f5d867538bf2063a0f4cbf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e0ac02af1e51d564be9abffff647c71f4b8d4f6060c1a9aadbfb9997a445f69"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    # Avoid requiring CMake or building a vendored zlib-ng.
    # Feature array corresponds to the default config (max) sans vendored zlib-ng.
    # See: https:github.comByrongitoxideblobb8db2072bb6a5625f37debe9e58d08461ece67ddCargo.toml#L88-L89
    features = %w[max-control gix-featureszlib-stock gitoxide-core-blocking-client http-client-curl]
    system "cargo", "install", "--no-default-features", "--features=#{features.join(",")}", *std_cargo_args
    generate_completions_from_executable(bin"gix", "completions", "-s", base_name: "gix")
    generate_completions_from_executable(bin"ein", "completions", "-s", base_name: "ein")
  end

  test do
    assert_match "gix", shell_output("#{bin}gix --version")
    system "git", "init", "test", "--quiet"
    touch "testfile.txt"
    system "git", "-C", "test", "add", "."
    system "git", "-C", "test", "commit", "--message", "initial commit", "--quiet"
    # the gix test output is to stderr so it's redirected to stderr to match
    assert_match "OK", shell_output("#{bin}gix --repository test verify 2>&1")
    assert_match "ein", shell_output("#{bin}ein --version")
    assert_match ".test", shell_output("#{bin}ein tool find")
  end
end