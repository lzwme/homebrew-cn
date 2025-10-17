class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://ghfast.top/https://github.com/convox/convox/archive/refs/tags/3.22.4.tar.gz"
  sha256 "add935b04e87c21c5d8cb7d9c5db8e7ad4bc4fee261edebe720c9da4513a2f8a"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/convox/convox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e47c5ed433047fe391d22ffc2b7e2ee8510ba4cdc6c668a262ee9f00194c4fa1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4716ee3764956406f49fb9a9083452241ad9a320719ab6599572bae388b5339e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3233c5703fbe5549e130b8ed9802393107e1a74954a63e8de343aa2eab7d778"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5557c8a08e9ac28fc799d198048d24b52cf001b1c3cc4c6db21b88869ddd3f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89b96616da80e6ddb102bb9340fc0c46ff0c99912ed0c80ed0bcc1d3293f75c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f14fd91db15100385e89134a460bdeaa31234e10d8ba3483a9f6688498c74fc"
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