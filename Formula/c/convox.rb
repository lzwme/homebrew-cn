class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://ghfast.top/https://github.com/convox/convox/archive/refs/tags/3.25.7.tar.gz"
  sha256 "942ad7a8442b0143fd48dcdc50e0e813992fad478db695eb321ad72061198c0b"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/convox/convox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9af2d1ab0144438ce2cb5c6c2af7021a7020e3f8245f62cbe0857d44d5ce1a33"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "98e2f719a1741fe96a03b806c01c5b87997a2bbb263ab69d2785e486bcad2226"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ad54c793b1f953193d6c41189537356b24325c46242235f8e348f530c7aca109"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e3acaf5f7abab1ab2ff118bb8fc32e1a6ee2c56339b16ed11757faca6f1145b6"
    sha256 cellar: :any,                 x86_64_linux:      "a44dec68b5aae3aaad3b76e0ba2a113feab268266cc66ecb6ac2e4d060972123"
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