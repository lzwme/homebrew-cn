class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https:convox.com"
  url "https:github.comconvoxconvoxarchiverefstags3.19.3.tar.gz"
  sha256 "43baa79010cfec572f0f4f2d2af21c671f2598e67744b0323e2671fc379745c5"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0a9ef4ab6b33eb1cba527c8a2e3637a70a0f656999cee722c17db1974d4db5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca3e9f392793a2ac5cfbab444b860b0aa81d1d59a8c3a3a6a2800836c193b41c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "20848bfd53dc72c35cadf5192392ae5908b7d9f055186218e142e8c8a016fc5b"
    sha256 cellar: :any_skip_relocation, sonoma:        "247e1882e4c987df52fed7ae771ea52a6976e823905f3b9cd89ee44b772f985a"
    sha256 cellar: :any_skip_relocation, ventura:       "09fc70b66ccb23f187872dd6742f74e534145ea105a3826c1e7ea04ded99eacc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17bf84f96562c814d9c3eebee13bc6a6e138826c08f1a580b68f4403e30b2030"
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