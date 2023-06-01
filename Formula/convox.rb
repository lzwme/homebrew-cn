class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://ghproxy.com/https://github.com/convox/convox/archive/3.12.2.tar.gz"
  sha256 "a6478edf35f7274109d0e7145ce0accbf25216080e882443eb2f7dfefcb252a1"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e82650abb1dcfcdede6b0bf123a11b91027c333e7b4e798a997a8260043e3c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29f64f1af703ebbf1c545884316dbb25eb03fd4a7f57c4982ca2d55ef7799a14"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "39b77df914eac5fc22eb9ea12418ab5c93c429555bb62e448c5010b1c11e5a85"
    sha256 cellar: :any_skip_relocation, ventura:        "a28b1242b6a342c3b0e278d42b08b41caeba117afa8b93edf490c89dd3f0a82a"
    sha256 cellar: :any_skip_relocation, monterey:       "3b94010e617631a1b955f3ea319e94ebc4b5bc36fd5308be04d18ad98848f38a"
    sha256 cellar: :any_skip_relocation, big_sur:        "e2dc8f7f0e88e2b442e95e4233ba3631f073bd5aa4973d3db71a2aa4c7e21c2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dfd8db2102ce7ab7ab03389787518d645d6aaec8c3a2aebe889a59d95c667d96"
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