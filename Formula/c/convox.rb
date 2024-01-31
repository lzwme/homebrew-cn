class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https:convox.com"
  url "https:github.comconvoxconvoxarchiverefstags3.15.2.tar.gz"
  sha256 "008e688bdfdc49ca62cbfb2aaab3692a4c3d9595add7090aca35bd7bb024494e"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "758dd021654c564ce3aed05b5c94dea600cbe602be8129de943ed88450dd7cda"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4947fea3f8048a0996d0cb5a93d127c56f952e35e089662319f8ae8ede414700"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf70a5f1dc19dbb535c0f749ed15c0fb47db92e9ab135d3162bd50f52305d87c"
    sha256 cellar: :any_skip_relocation, sonoma:         "f8d38bd174aa7d2b6a1985dcce5d2c7b3735df5fc7b9e3b6e45dfd83d919af95"
    sha256 cellar: :any_skip_relocation, ventura:        "d297c388297a7ec36ac729185a46b116145f271934ff08b701fcdc7bbde0e452"
    sha256 cellar: :any_skip_relocation, monterey:       "26b29aa10e076f6f5ea057b4e9ad09a10ebdb15db77bdf05b321146e5c398a7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05a54e50acac9bf6a5676312f84a0fee3ab19a2824ae849775466e2dcf337ded"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]

    system "go", "build", "-mod=readonly", *std_go_args(ldflags: ldflags), ".cmdconvox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}convox login -t invalid localhost 2>&1", 1)
  end
end