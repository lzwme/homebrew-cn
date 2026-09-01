class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://ghfast.top/https://github.com/convox/convox/archive/refs/tags/3.25.5.tar.gz"
  sha256 "05626f2e109108b9cdc67a7e25269d0e3543765a80b5ceacd581378f73f8d9c8"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/convox/convox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b7b78f9683f9889fb0a45ae8bc713672653c79f3785f6ae18e1cf17c97bc8ac3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49c16abc75ab6657df6ebe22a8d83873b7bea685f6a3b54db778e05bd789f074"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd7361da2cb690d5155240b8f2f7f496c1ac46d707557b19e037cb96955988dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1616e65867c41195d2ad2bc4d848557a9bb4d92b0da7a229f0e8303813bd6c3f"
    sha256 cellar: :any,                 x86_64_linux:  "184acb97016c3889eba6a2909402aeecc5194caf935239c265599b0986d00fe1"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "systemd" # for libudev
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