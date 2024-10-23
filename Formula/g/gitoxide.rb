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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b6bafa4c7faa6bf1167e9147850c96051e9fa5e463d7208a1c37d43524ff2a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49e77611b7e449adcea5b5cff01245eca2291c9590b7ebe7c08f937f7782a862"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "99f8253dd310aafaa065fe67446a893d833e74f158ab5176bfe2ac85217884f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "59860719333c52b6ff86bef7c4319e961b79fe93f6967828799a6f445c34d31c"
    sha256 cellar: :any_skip_relocation, ventura:       "e098104d9cf735ee32f168742e67469f7d6b16743566ad710070182aa583028d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4572d3c2dfaa7b7cc8abcd331d1a893d69dcd7a422967f2c6a4eeb24bfb8e6f"
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
    generate_completions_from_executable(bin"gix", "completions", "-s")
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