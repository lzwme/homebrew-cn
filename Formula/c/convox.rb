class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://ghfast.top/https://github.com/convox/convox/archive/refs/tags/3.22.0.tar.gz"
  sha256 "e455d3d7bcc2c0a9652e4537c894608ce435c38a182fc1c49633d3429dd02dcb"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/convox/convox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84f385b555da45cca7d3e54702d694754f38af5d0f311a63493e18bd5559a920"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "664add9cf89c4b5baaa3d8eebe4ddbb882bb0ac6aa26ed9a9b0e7eeb18e4beaf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8dd92d5c3ed08cd7c02c6c804b9a815d826cb3125d916933dcaf7d543a72f9ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "59d6451279b478612d771b7f30a47eac08453911120b96f4238e43234b2df0a4"
    sha256 cellar: :any_skip_relocation, ventura:       "d3da5be52c4cf8eae06ae725465c7dd1fcef25ebecfd4e45873e51892712b9b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf8be77f0481e0bf7a50d79a69d60dbc230875efcc45d64553691a1a4ce6a4a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47fbef30054f68356f27c957ed7ec967f31803fc7d78ab24b19e24957428bf6c"
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