class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https:convox.com"
  url "https:github.comconvoxconvoxarchiverefstags3.14.4.tar.gz"
  sha256 "d0c841f971fc9ad1ad028b3148f3727493bfede144a4425dc893148da67538d3"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "08b9599f9a30134181d2149293e9970b2fa6c99854ce7032e3c8aed1b6d8803a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9ab433194d4c079d293d98ee6ef760833888d437cf7c16e186d1865fca334a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ecc2e3661125b6e017e92f328630ee368d6e9e5d6b64580b78d024925ba5e53"
    sha256 cellar: :any_skip_relocation, sonoma:         "cdbfd1a561ca72b8984c2ede6e60e8ac85b6d74523153971902cccb8709001ed"
    sha256 cellar: :any_skip_relocation, ventura:        "34d55e9b349ec650e4422086e78c8eb6b50c6132c80083bc5f20f1d406e96c79"
    sha256 cellar: :any_skip_relocation, monterey:       "acbe5864db2f848918d067e02a76f4dc96cb9ea117ff01e9243342d3c8c6c28f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35848f584117eaab4089e94dac5fefd60b7e30a590c9bce704dfea932efe2a09"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]

    system "go", "build", "-mod=readonly", *std_go_args(ldflags: ldflags), ".cmdconvox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}convox login -t invalid localhost 2>&1", 1)
  end
end