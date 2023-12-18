class Algernon < Formula
  desc "Pure Go web server with Lua, Markdown, HTTP2 and template support"
  homepage "https:github.comxyprotoalgernon"
  url "https:github.comxyprotoalgernonarchiverefstagsv1.15.5.tar.gz"
  sha256 "00440c18ebe08c1498c0ddfbebe10e5d70936251295d9ab0d8673a431e38cd48"
  license "BSD-3-Clause"
  version_scheme 1
  head "https:github.comxyprotoalgernon.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8ba855555fe8b2057592dbc6aad4679420d61ec3c1e430702aa3fa91b5de9406"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c23387da532334dabfbbf97e457b951d222ae58df9f4c1943e90634c2b0df96"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28bf82cdd9ddd774cbccf624c808a85cd9caa1c07066a07d7f1932767f935823"
    sha256 cellar: :any_skip_relocation, sonoma:         "eb7bdcedc51601b62806daca7f7be8aed6ae500fd6d61fb8d3f010d7055556c4"
    sha256 cellar: :any_skip_relocation, ventura:        "b4aedb8dd71fe7cc47895279cd1da496286f24f1e5d811bb82460c64336285a7"
    sha256 cellar: :any_skip_relocation, monterey:       "2a71c1f386723799cfd9448a0eb5d39ce7b6f676cf959db692be05af014790c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a4bd7c09835ff212d601a2f7ebf5b9870fc7acb51235714b07f9f37d41f713d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-mod=vendor"

    bin.install "desktopmdview"
  end

  test do
    port = free_port
    pid = fork do
      exec "#{bin}algernon", "-s", "-q", "--httponly", "--boltdb", "tmp.db",
                              "--addr", ":#{port}"
    end
    sleep 20
    output = shell_output("curl -sIm3 -o- http:localhost:#{port}")
    assert_match(200 OK.*Server: Algernonm, output)
  ensure
    Process.kill("HUP", pid)
  end
end