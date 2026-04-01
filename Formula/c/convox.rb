class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://ghfast.top/https://github.com/convox/convox/archive/refs/tags/3.24.1.tar.gz"
  sha256 "c445c3c8678e11f7f9847c49b55891116f206d9aad794b0f55afe8d16ca3ecc8"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/convox/convox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "32795fb55d4b5c8e8e6e5e04b75c0386ba344f471dfc15cd2a5c637931e7b0ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1043eb680f23f38efff0695c3763c9e8945bea5f4326df61e633a4728c0a182"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c258b5839d75c8047a32247d6900e793f7167109c5e266b47918031dc54bd65"
    sha256 cellar: :any_skip_relocation, sonoma:        "8edbeb6969031990d2a13b4389ec108f0cf13c4868f1521f875bd54b6e13f854"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd54151b5359565c39d13b78dddb5cc8223b1121b35e85a2d90bb5b63db69a63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b44c53700786562ebddff055cf3b6352c8532564fd08169e60da6daf6fcdb6f8"
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