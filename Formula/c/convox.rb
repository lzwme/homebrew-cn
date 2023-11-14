class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://ghproxy.com/https://github.com/convox/convox/archive/refs/tags/3.14.1.tar.gz"
  sha256 "1c778ce5709155fe46aa82208934b24829b45d3199c2e549c11c9df9179c2e18"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b1b04cf2ad47087d21c7d5464da8446fb6779ef7c8d3c0b8920ffc5450a87dae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae0df3db6c218177d1ff79b5f03142ca12dfa750fdf873fbdab90a11a32c456b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "254665e082961c8914cf9b0b5d1b7484569fa7c6fd1e80f7cbb9ba9e996917da"
    sha256 cellar: :any_skip_relocation, sonoma:         "77fd7a9baa98d94f798411403b2f9cb30b927c44c1d330d290b10aae1486fd5c"
    sha256 cellar: :any_skip_relocation, ventura:        "f35325eca6656282d43beed5872262b58f260f21d0d0ecbaf397973793c82b59"
    sha256 cellar: :any_skip_relocation, monterey:       "4622c716cffbd7f9c399e8debd40f5fd9204425631036db40663a10c3786d0cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4803e2ea7170c7f3951bd2a12863aae67f34dc7f5146b42465f45e1678d561f"
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