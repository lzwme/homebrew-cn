class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https:convox.com"
  url "https:github.comconvoxconvoxarchiverefstags3.20.1.tar.gz"
  sha256 "3018f92163338e651d2f87f4d58b91aaaf8d908442f484e34927e13228042c8e"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5cde8bab7600e13780855111edf230fa7450fd857f4c49a992675893efa2b2e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2ecf7dbed94477d601574522222fd97cce0a2269aaed7f9a347bde41e3963c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1bd8ba094164a0582d8143220b56279caf2fec56a19a3d09e4e38bebcf109b8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2b4e662702f07d270e61ecee33600dc1f1d278046f0ef484c462518041e6d84"
    sha256 cellar: :any_skip_relocation, ventura:       "357006f2215e8d1c80bc9ae4390309b9f094643507e67d030df6192091500cc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f47defe4a47dd1fd5ee593af80ae6223d0e313726cba8cc381862400fb278e5"
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