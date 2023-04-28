class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://ghproxy.com/https://github.com/turbot/steampipe/archive/refs/tags/v0.19.5.tar.gz"
  sha256 "f01cf2a6b9d17a9bb571b754a50d00bbd44bf5073237c1ff3fb9fa61d5c9348e"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f832cc41df8bac07bf80f11538f773649cf838e1b50263543cdf42f0ac579a59"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "660317a61c1b009c4de82fc3c3895cefcf271baa4bcd2c0242505be504c918b9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "502acc859892b5ecb4cd43bc4e305bddf4ed35482b505d531e4141f2af86e52f"
    sha256 cellar: :any_skip_relocation, ventura:        "f707be4d94a952e69814d9a3e4ef1ec4bb25a7ccd75f0eb2137f1120bcaab5a5"
    sha256 cellar: :any_skip_relocation, monterey:       "dcbff0d3324b5fbe2a1c5ff8d302f331a5ff37956ca2e68aedc0c310f06c898a"
    sha256 cellar: :any_skip_relocation, big_sur:        "2bdedf97868e55c786edd21927c3af692d0c6e97d0099221bf893980e07aad13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc02ea585fa330885bccfd07f2d703fc7d9a289268f3474a69e356ea129f5292"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"steampipe", "completion")
  end

  test do
    output = shell_output(bin/"steampipe service status 2>&1")
    if OS.mac?
      assert_match "Error: could not create installation directory", output
    else # Linux
      assert_match "Steampipe service is not installed", output
    end
    assert_match "Steampipe v#{version}", shell_output(bin/"steampipe --version")
  end
end