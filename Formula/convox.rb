class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://ghproxy.com/https://github.com/convox/convox/archive/3.13.0.tar.gz"
  sha256 "bef43d3b5922fdc0c8a396bdb8fad520ffcc56fae92710e4c96d466411fd4c07"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d79236120aac349f47c580d4d60ce20d9dd013e71173ae06bc92fb2bb4f44bd7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54441b350655d5088921a40f62b619038aba6ac66cbd60762435dbe80d474b56"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5523fc5da2f77c32bc1a4068c069273b44779db899b8e3ef4957fc933e945670"
    sha256 cellar: :any_skip_relocation, ventura:        "f4a6314b7698ab6b9c5ed0144fe77be078b59b2ff8bebc6d887b4ae48226401e"
    sha256 cellar: :any_skip_relocation, monterey:       "7d0293b1089a67eb040cf18213a2d9a499c48acb84f8eb5eac68be5d3947175f"
    sha256 cellar: :any_skip_relocation, big_sur:        "943452f5f2365c3e753f505f20bb6a1e249da743afad72ad267551d0a07073b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4adc66a4bdd2185147769eee6e930d24234a684d2926ae31ae6961249032f6d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]

    system "go", "build", "-mod=readonly", *std_go_args(ldflags: ldflags), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end