class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https:convox.com"
  url "https:github.comconvoxconvoxarchiverefstags3.19.4.tar.gz"
  sha256 "b3fbd8783069994e6b5bc974c6c8c35d3506602abe71cb21b29facaa52deaf94"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07b12fa8c11e8e1b5103d7bce759cc25b5374a6824e94d43c0eadf9d0cee1def"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5ec8fead3f246f9a1ce1aff421400a57cc1ad987327320eb7fe0f4f4c18255b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6776f8c66ae7ec56e95afef9e962cfd2e24a07dcb86004f533658456e56aa0ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "484c72e113933ec88df7c6dc32dd9d6c3e1fdaeaf6a3746cd6affcf46c0ac554"
    sha256 cellar: :any_skip_relocation, ventura:       "03a52af2d65f2943c4664f7cb76e77a7082c4b67354e52e09ca9ba39cf604507"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4db376aa1b4d269c939ff544f4c158cb961f1ea38c9760a6dd02fa1ca74bd00"
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