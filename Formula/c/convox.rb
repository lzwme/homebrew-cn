class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://ghproxy.com/https://github.com/convox/convox/archive/refs/tags/3.14.2.tar.gz"
  sha256 "7548d925107e7f65f55870542d25acdd854793275f7e61e6c37ae635c0c6b02e"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "38c78df3b0f6f5e40da3625a288c6536f646868e137898741436ebfd517c663c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71061b6207fe642a62d4b8a70f9ff7d25637a1a952bad667106b240f65066c2f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af74b5c8f0c77a908fb79aad926da52f75c3bdac6d875e6c21a5a4447d88408c"
    sha256 cellar: :any_skip_relocation, sonoma:         "f609cc94d036e50d025b6b901e0fc37ab339d2892449a2d83b3a10472db819de"
    sha256 cellar: :any_skip_relocation, ventura:        "42bf80c229cb4937e4ce0313cabde00c4ba3c81920c00fdea5681cf6961dfb18"
    sha256 cellar: :any_skip_relocation, monterey:       "2710db883e89287f0d4aabdddd55a3cb8e20c9e485134ddaffcc86d6892d0cc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b3821e8e373318450013f185e65598140b8cc7b12c2a56bae29f50ce5f4ca48"
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