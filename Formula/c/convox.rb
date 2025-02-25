class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https:convox.com"
  url "https:github.comconvoxconvoxarchiverefstags3.20.0.tar.gz"
  sha256 "fc8470df9ec15637b1c6682a28194254f0da0667109a8e7d3df66ef1619d99d9"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b10aea5f4fb61bedae67d57e11050765776cda209f84ce7121c3c2fb4066ea62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07afffd7e84e9a03477204d4cb2aa88d190352eef8b5d8b185aa9e3294b550a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9a35a83b8616fb2f0e893535597457e50953c47cb3e36c587062fb6fe72c7d31"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c1d24c0b3d90679e6fc9ea2d287bd1c21cd57efa1abd318ab2d0a7e52c7d97c"
    sha256 cellar: :any_skip_relocation, ventura:       "0b32f51beff845155d69231cc58abddef2599b412f0b876d64a69c3cfda348f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4782248b71f08d5fd4913caf4b27c385495dbf4b09690562e6f75bfa0a6a25a"
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