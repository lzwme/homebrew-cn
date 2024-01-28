class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https:convox.com"
  url "https:github.comconvoxconvoxarchiverefstags3.15.1.tar.gz"
  sha256 "bb1a6597406b26ec6b2294c29affd953959fc12fb973ce80bc4e38329ce51d8c"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8ae0073d44c8e04303a0b41476c5b854e47dca4b48c574449a03b6a6ea185527"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "49ef324917eee89d66938c6794bb4e735b6fb0dbcf2727575787bfb29809a718"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b3452188072993a08b52e97c78e8113e3fb9a94925c65f9d502b5184a06c583"
    sha256 cellar: :any_skip_relocation, sonoma:         "4422874caf7372bb36e3ec3310d64e9d59bc6e2576aeedee6c97deffdc2735c4"
    sha256 cellar: :any_skip_relocation, ventura:        "2a5d12cde019fc2dbcd74ecbd9e76b98838093d8f5430edd9a9ff8ffe6b82fd6"
    sha256 cellar: :any_skip_relocation, monterey:       "7886689358291fc3b86a7a344b1d747a1240a12ca5c94145293c02cd0c6c1f0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33798874a3225eaa8c9c303907ad14ebfabf20e5b1a395ad35c49e3a9409733b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]

    system "go", "build", "-mod=readonly", *std_go_args(ldflags: ldflags), ".cmdconvox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}convox login -t invalid localhost 2>&1", 1)
  end
end