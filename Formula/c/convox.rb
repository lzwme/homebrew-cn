class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https:convox.com"
  url "https:github.comconvoxconvoxarchiverefstags3.19.5.tar.gz"
  sha256 "5a752491dbd5b0e0649e2351d6fab4ad7305efc38894f562404080e79a473fc4"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9aaf2be059f2d3482cbd095cfe5c7be2af0ae4ce2377962d27b91b6e93aece34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "424e6094f1afec6f79e734c567cba59794623b6842144859c61b634746e62794"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5f1c1586d1e9c50890f926d28dd4ad43228eb43c26a82ac3a1e3dcff2e028c3a"
    sha256 cellar: :any_skip_relocation, sonoma:        "48b6754692326e1f7cc79bf849ca90d940b49b3d1b78568112059a7ce20f1515"
    sha256 cellar: :any_skip_relocation, ventura:       "88a0f19751c0071290b92d1e8310a8016982f06a1fdf31fdd69ed1c32c17aa00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91d51fa8bcdedae104f927591355fb14e18380cfa4db8c1a8886a1ed82422f1b"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

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