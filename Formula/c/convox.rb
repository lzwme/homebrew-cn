class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://ghproxy.com/https://github.com/convox/convox/archive/3.13.6.tar.gz"
  sha256 "bfb161b23a1bd2eb35db1fd9a2af20e4887872ee9cad1461091301d7441255d1"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "346b9d77b3fd97d41bda4cca160f5b294ffd348cb3e397cebecf098df575c1a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6808f9d5c9e81a742c1119cd75da919ee44a33b0d9b373998ba46a656764d74c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2264d65a3a9cb19aea540ab3c14dc1a85b176eb6026934dde0e6d31f289fe34a"
    sha256 cellar: :any_skip_relocation, ventura:        "a3f570bde45aab060add6c7d6c08fa9715984bf8acb1fd888cda1e8dce1489eb"
    sha256 cellar: :any_skip_relocation, monterey:       "eef82142d055156b735d595d27064c860568c65ebc4f7933893c5add5fda0600"
    sha256 cellar: :any_skip_relocation, big_sur:        "3748e6fa90ae9b154afbcd6ca0634d2a02927c5a1537e5fe01c1e72c8efca427"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc5810254450d99921e24aa9f6c9454552081f971eeaaffdc4ea900214772a77"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]

    system "go", "build", "-mod=readonly", *std_go_args(ldflags: ldflags), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end