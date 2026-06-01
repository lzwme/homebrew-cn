class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://ghfast.top/https://github.com/convox/convox/archive/refs/tags/3.24.8.tar.gz"
  sha256 "67662790549bdbc8e6d1257490ae85917629f9faebfef7ef5d3c7a3bb7d8a65c"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/convox/convox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c6183a0f8ddd6e40c783b360e79dc65b7a1d6aeb858d3f9c678a8fcf6ecfabc9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4ba516331bcfee838ae038f4dc3f6e7f35e0cc34d6aed82adff8833f41ddbb3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb159d7ab46eebfb032d5b2ba838f8a51185d712d4e2df01f80e6465bbf4c96d"
    sha256 cellar: :any_skip_relocation, sonoma:        "439ce53c5b973d567610f7ac2ac051a974f972b26d802fe70877ebd1a892f57b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6bb4f38f8aae92649c438f3427abf7daa24d41cd5f0342e874f4f35376ae3fb5"
    sha256 cellar: :any,                 x86_64_linux:  "7acec692418b2abe84cc26fd1f533dff680d949ddd9a41d6948029516da8075f"
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