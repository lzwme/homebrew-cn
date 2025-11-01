class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://ghfast.top/https://github.com/turbot/steampipe/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "c0a1384b005ba89743fcac627a969d714fb53b253ff020ab647879c258f80c01"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54d92583519f01fa627b850efda7ef6192628b5152425f5ae0a521fee1f9e11b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b46a0a50e091397003d1550193c9b8e2891bce347aa80be4ceafe342df6ae340"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4eb804e0fe834f4d1343b1cb830e1fc23e55e4dc598ca14b30dc66b345a14fe0"
    sha256 cellar: :any_skip_relocation, sonoma:        "c58da436fba48c6784a0c8c57e5539ceced08fe229cd9d6977107ec1c5505edb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31ff4d6ee297cd668571377602274be4f1863ff5555d833b15ce4a2f919729dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9e34ae64ca5645b74276fb004c1bbf86f7f3bd66d2558d87c42f77fbe696dea"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.date=#{time.iso8601} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"steampipe", "completion")
  end

  test do
    ENV["STEAMPIPE_INSTALL_DIR"] = testpath

    output = shell_output("#{bin}/steampipe service status")
    assert_match "Steampipe service is not installed", output

    assert_match "Steampipe v#{version}", shell_output("#{bin}/steampipe --version")
  end
end