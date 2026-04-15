class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://ghfast.top/https://github.com/convox/convox/archive/refs/tags/3.24.3.tar.gz"
  sha256 "827a92fab7e350916d0b3d3dd0f4c622623f50446f5ef40bbf99f6873e5b510c"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/convox/convox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e5f1016727c74ef9a3a03f560d944506717263b89210f031830654346752ad6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "528f8314d44b4d5112508ef533910ee0a051ba3116c4d113b9817ba4f04cc8a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d50dea5bb8764c1571065799ea5ebdaa41b3a357a93153b27c8c08ba8dea3a16"
    sha256 cellar: :any_skip_relocation, sonoma:        "2aa5e5de0118a6062fbfb15c8f961a0c70024a0f08026d84cb5a9ab8f544b434"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dcc401ea6a84c25ee28780827b207c9cc899291014f65abb5a1653fb8f94f541"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85a25295fea9e8618660f43b00bc67baf285bde1a6223b946059ccb755b7d975"
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