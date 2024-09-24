class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https:convox.com"
  url "https:github.comconvoxconvoxarchiverefstags3.19.0.tar.gz"
  sha256 "e95e47d6ffaebc9c8cf39765932b6303cdab96df488a1b11f9c1a928b35a89f1"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f9cd83295cfef0e1adaadcf98224a84677c52f75cd3b064bb2437e7f7d18a9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f55cb8c4299133b1ec311608f8b951f57c3ffdd947d3832688e4a2d18de0f0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "87f707cdc550c4c0ca99c8bc0874dea495dd5a8dba5b60c2e2bab4f33e0fe3fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7a3121f9079055ab7c9442a4df8a576d26aa0668494cc38563771bfb15f38bb"
    sha256 cellar: :any_skip_relocation, ventura:       "6b92838ac084f77f50a3153b871cee741df4625c782076409958b01672b42897"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94ba9f21d009c88c174e838dc2ffbd7e07dc5038a18ab78fb98d604d2390c124"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build

  on_linux do
    depends_on "systemd" # for libudev
  end

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", "-mod=readonly", *std_go_args(ldflags:), ".cmdconvox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}convox login -t invalid localhost 2>&1", 1)
  end
end