class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://ghfast.top/https://github.com/convox/convox/archive/refs/tags/3.23.0.tar.gz"
  sha256 "a44b30db814211de6766d84a2677b755929eae95056fc16af16ebafff49e3097"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/convox/convox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e207708bb7f6316008bab5fd52913db4267a35d0e86f29edc211abceda149903"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e974772b4540c982173d602c6b8949afa3901a0fdc05ce064fde240695f4ac12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0539853b873f3822699643caca90cda96adf9f67fca76d1499d54d23f27949a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "97288affbc1e7544982e48781d59c89495e07251c2f6216776298b4be13956d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe55f35413d1647074e37970ab2fbf5e0d0f8d8aa265ad8bdf08b5e9c3a126c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d19b53b176991a27fef6dd3a53d6948a82cb9815b55aab006de3cdcb6841c21"
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