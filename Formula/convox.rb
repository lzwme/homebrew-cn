class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://ghproxy.com/https://github.com/convox/convox/archive/3.11.1.tar.gz"
  sha256 "339900df86a757bd986f9d9170be7520da397ca1ee39979eea0d8e05b80f0f10"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "06bf534b6aa178b1d5e08607f9a5f81703a4e89a4aa183b03b5cce5dca549052"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0eb1ea02c83ba89b1976d9966e5953e4732a5519bbf85519cbc0828e2028e886"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "19cdea77057d961dfb68c3d64d165eeb33286b1de08edd0dde0b7f69ed22be85"
    sha256 cellar: :any_skip_relocation, ventura:        "fa6ecac6aecc0a910a4e6d669deb1f4d5dedaa67d3184372c78262e853a5a0cc"
    sha256 cellar: :any_skip_relocation, monterey:       "c9fe016a26270bcb293123a2c1ff0d025c0b3ac6c9f238d610e25ed58cfbd745"
    sha256 cellar: :any_skip_relocation, big_sur:        "9914bc69f279d7e34350f764099ca6821177505c3bb65b79f4476b8aed31c97e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92c3c9e06ef00344c4a39d52002bf74a5938eacb22869bb7f78b486950577539"
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