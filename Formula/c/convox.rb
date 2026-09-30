class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://ghfast.top/https://github.com/convox/convox/archive/refs/tags/3.25.9.tar.gz"
  sha256 "1d8bd677aecf164b8c7f313a54301dccca446c2f562294f198f9f3f6913f17d2"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/convox/convox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9ed6f35183a47187aa058fcaf8901db7e18a5d5d74c7e1d80beac9ecc28a4823"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8e83c5fe7f31b4724d17f3e2929fa8ba95e5341a2375729cfb525d2b5c9c272e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6d84f0c32ff774888a901e2dc57ec428063cac96050c85e15d3733e51e7ce2a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "451fcba66c49457b07fa9958d6b9cfb36e6fa091b9f9cc57f374dee75e01178e"
    sha256 cellar: :any,                 x86_64_linux:      "d3749b4867e36c92c3b27a50ce4636c79bdf2d2f5a34deaa76dbf76f8a7382e2"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "systemd" # for libudev
  end

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", "-mod=readonly", *std_go_args(ldflags:), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end