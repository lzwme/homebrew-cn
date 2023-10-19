class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://ghproxy.com/https://github.com/convox/convox/archive/3.13.9.tar.gz"
  sha256 "160a3cb9a4705f5a3e20e2ee1b28ae75da189b1394b20daa021477544ccd94a3"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "95826cc74ea5eb6232bdf91c85083e0ce60787e48f0ebdfe7d8e85bb80ec4488"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4df45e1a42be97e37f17466ad3ebc09e0aadf1700b6db7f47f8a020a0eaf75a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a23aa622ddd81c167cc31b864c3f9f7e85b1317300f41dabe3e6da770b5c3d3"
    sha256 cellar: :any_skip_relocation, sonoma:         "8096d0eb8343f7d894c1246a471eb7aaef3744167b9872404c749131a2a352f3"
    sha256 cellar: :any_skip_relocation, ventura:        "a92561f6fc58452c9781154975e63f5fb76a573f9a4c46249508100909b43469"
    sha256 cellar: :any_skip_relocation, monterey:       "b5fa4f67a9f7e3d823d09ea75d739d96ec9e90317500475e33475c69481a947d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "106836df027661cf24fad01cf92abd668d5e065c5d22c2e05f1a9706b647487e"
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