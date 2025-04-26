class Gitoxide < Formula
  desc "Idiomatic, lean, fast & safe pure Rust implementation of Git"
  homepage "https:github.comByrongitoxide"
  url "https:github.comByrongitoxidearchiverefstagsv0.43.0.tar.gz"
  sha256 "add692b639a8bec599aa9c67560ee35d8c9d8bfdbf05645b2d923546a19b4401"
  license "Apache-2.0"
  head "https:github.comByrongitoxide.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14a68e0f8a80b2a87dcced6f9ef5c50d4b91bd17f85d045c9c3bdd7b12aa524f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7ac7824069fe10bfaefe900f59cb6539f7f0e3e69bef21886a716284dff0502"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e4063598a0e9e4a26f3a9f988be6baeff8b01fc4b11d1664a8a6e68b1d51183d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3b27d3322f382b514d0df35f2e581fbaafccfa3e2ce3ee43cc1fe27ef83fb26"
    sha256 cellar: :any_skip_relocation, ventura:       "24ff1a9bd9332756d77095877d4c6cc0fb255ce8e0033f608f8151b50ef7ba95"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a224e91d88a842b0f6ba3da3c675549cd3a53f633867649652470c10678d6acb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca22c01e80bec42362f1e558298ca3e029ef99c8b9c4540a2611c285a6e14b67"
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
    generate_completions_from_executable(bin"gix", "completions", "-s")
    generate_completions_from_executable(bin"ein", "completions", "-s")
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