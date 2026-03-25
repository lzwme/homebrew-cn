class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://ghfast.top/https://github.com/convox/convox/archive/refs/tags/3.24.0.tar.gz"
  sha256 "18a896459b194452e741e36010c11c8dd8ac584ed2a80dead82959b6f1844a27"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/convox/convox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "767df3ec0028124966023088ab98dee41942e04c6356955a70f12c24392f5f2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5104d48dc09e87d0cc37d31310662cc939b5a16edd7a8d50ce57987dc2c11c21"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c16d4d82663bf14fd806d49bb5bcccbd2039e2f62561ca0008e290c9569ee87a"
    sha256 cellar: :any_skip_relocation, sonoma:        "4816bd584ce274a6f1dc5a97c516e6f1a1634842babf8cf98377acd622657448"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3bea74bbcdb99b28a0085ccfcc977743b4b0d4d6fdbcd0612bc9fec8fefe8e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79d4a553aa9c644e7db35c7cfe320ce812eb0b106efdc72075e34804dea9e46e"
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