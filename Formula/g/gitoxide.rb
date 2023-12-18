class Gitoxide < Formula
  desc "Idiomatic, lean, fast & safe pure Rust implementation of Git"
  homepage "https:github.comByrongitoxide"
  url "https:github.comByrongitoxidearchiverefstagsv0.32.0.tar.gz"
  sha256 "5a17da0379254bd996fe1888de4104d551a41bdd8bd4b93034f9d0757382fa75"
  license "Apache-2.0"
  head "https:github.comByrongitoxide.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4c426e70f9ae0bee16722aca12218c1724555fa53763111727bd248701e14f3f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76a029d546870d41a53cd10d2ebb236b160e01b4e1851fe0edef2023aa80b247"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "404db5adc663a2432a67e6b4b39e088c01813cfe4b6a814cbe133bc9f41300d6"
    sha256 cellar: :any_skip_relocation, sonoma:         "1afae551b5ac6539314f4524e3b3c3d9c27d7ecd394fe48030aa40c2b1bfcf5a"
    sha256 cellar: :any_skip_relocation, ventura:        "79752a7b18f60e2318eb9086b9fb2bcd2c340020cb853689f6d6f287d6e73545"
    sha256 cellar: :any_skip_relocation, monterey:       "bdba20ce126b4cbe943943678ad857f5b1766183ee354612833c2f06b1571163"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7362ecce6c9ea07ae7b1e1302d46a061bc707b2e178722cdf876d612b467d177"
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
  end

  test do
    assert_match "gix", shell_output("#{bin}gix --version")
    system "git", "init", "test", "--quiet"
    touch "testfile.txt"
    system "git", "-C", "test", "add", "."
    system "git", "-C", "test", "commit", "--message", "initial commit", "--quiet"
    # the gix test output is to stderr so it's redirected to stderr to match
    assert_match "OK", shell_output("#{bin}gix --repository test verify 2>&1")
    assert_match "gitoxide", shell_output("#{bin}ein --version")
    assert_match ".test", shell_output("#{bin}ein tool find")
  end
end