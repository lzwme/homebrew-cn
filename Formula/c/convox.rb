class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://ghfast.top/https://github.com/convox/convox/archive/refs/tags/3.25.1.tar.gz"
  sha256 "2780d098ac815d5e509edc72b09260076d9bba29c633881192651651d5b728af"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/convox/convox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa6621274fcf169fdf21747f4631b05ab907a4025fc2d50b11488fd9064a9bc4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22f2a662422b56add58046be4446552af89184a5a6e6a604f2d2ba2783a89ea1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d9c169ec2ce520eae31d0b93b132783a3209a335d335cdabfd7e8b865c0c85d"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe680aa80c302a71e1f5742d3c1dea773954c12ed2b78d5b09af76269008cd5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "209efea24aaa1f9dd6ff9435aba1444f164a8f3df037a0743a2b53b72028fc16"
    sha256 cellar: :any,                 x86_64_linux:  "f6c6b830204910efc37347b4ff99d6fec4f5e1ace280f474858d497c0cfe3e49"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "systemd" # for libudev
  end

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", "-mod=readonly", *std_go_args(ldflags:), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end