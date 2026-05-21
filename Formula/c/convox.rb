class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://ghfast.top/https://github.com/convox/convox/archive/refs/tags/3.24.6.tar.gz"
  sha256 "d0e5d43b7aaed4206918e43f98ca0524079c47eff38beb666b3422011fcf0e4c"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/convox/convox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4df48eca1e4dccc70f446d1c001b9281eeaa941a93d230ef9e7a9cd277e0ccd2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04df2f2327bf8fccfad88e7806bb9494ef02b82426060ba78596388dc65d4fc5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "928715b9048b4cb9a12b83d904e5e00ab5508b835182215dbb68b1adac97910e"
    sha256 cellar: :any_skip_relocation, sonoma:        "e179d3da8db252b3aa7d1393852f04d589247ec6be94615dbe68645f5ae0fc6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b0ac4cd46fdca058fdbfdcccf74bd61dd3a5d820bb4d042e9ade4983ff6cfe4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "462155242c27d653cd53f6b1caaa2bf64fe44f9d51a9bf63a3e06a645845c96b"
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