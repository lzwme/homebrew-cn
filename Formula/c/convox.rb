class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://ghfast.top/https://github.com/convox/convox/archive/refs/tags/3.25.3.tar.gz"
  sha256 "3b334fb071c2b1468a8d5a27d67d5740302313f99dfd12f3a4d6ef4aa98308f2"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/convox/convox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea256d86b241d024828cb511e23a3489da04157a922905c6fa8f39e5445c20d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28067794d5ca706870dd6b8c9f482c7b0a3c834035129c0b18720bf0096501b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e09b1ffe7bcc72cc6f378fc30feb2e7100ceeecbf457b29364d79d5bcf691159"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1bbdcd8f47429001284047fe86ca76c773eee2317ae5febe8a4a65e3c2fa534"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2dbbf19ac6dd832610a87c94ed327ed95b5593a73dc45ea029735944a71b9d24"
    sha256 cellar: :any,                 x86_64_linux:  "97fe46392954a62dca332a2318bb8df86fdff10468e725e817f2a1a78fba6948"
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