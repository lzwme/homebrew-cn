class Gitoxide < Formula
  desc "Idiomatic, lean, fast & safe pure Rust implementation of Git"
  homepage "https:github.comByrongitoxide"
  url "https:github.comByrongitoxidearchiverefstagsv0.40.0.tar.gz"
  sha256 "fe0ed165f3325176e7e7abff1d2a819a473a332ecf48921931756c3289405e86"
  license "Apache-2.0"
  head "https:github.comByrongitoxide.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "129ff38ba268b5cd8e80ac1969df204a9c2e10d4debfb9468e7d1ee22c3abc33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25be403a8907cda6fb5bac41b0ee5415c893a8523fb6bbbd2ff58cedb30cbd74"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6f108003db5656bc82b63bdefd6933b8725334820b6da4a391a6d8e3718701bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "c47b6e643d5195816e9eb61b670033f7aeb02d85380d7e6332c7eb8339e8d92f"
    sha256 cellar: :any_skip_relocation, ventura:       "808fd03a3d94c30523d3ed1fbe5ad5a195be2a60bea8976f45af309cc87dc697"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec57c1d83b956e9ca21f75deece3407f7de0310d531fe41aa5ef50d0af11e8bb"
  end

  depends_on "pkgconf" => :build
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