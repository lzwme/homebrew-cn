class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://ghfast.top/https://github.com/convox/convox/archive/refs/tags/3.22.5.tar.gz"
  sha256 "fdafc9a8092eb5f8fc35d619eb054d38544ac694dbc850cc1e05ecd2e06b6cbc"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/convox/convox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "827531fe08a2f748cf51b59356e125a5a9ce85de98030c52625b77c966d76cb7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea1317845d1c194c14e585c875bb771742beee0e2d9a58b2000d70789b43c0e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d59ed0ad745587b23ec9d898c9d1ae0cc3c7b67b3469d38da9295dd0f57b2a31"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a4a0112c28f6503b398c3657971717407c604cfa6085da7be564e04ed4109ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6cd3102fd2d68ab542ce688ec5642339e1987a62f47b92b05af080483911a1a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98644763aeb65dacbfdf6bee97874867090b6cb0460d1a22e84661679042d183"
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