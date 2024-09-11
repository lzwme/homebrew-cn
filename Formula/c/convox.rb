class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https:convox.com"
  url "https:github.comconvoxconvoxarchiverefstags3.18.11.tar.gz"
  sha256 "86f82d31c7cc11195f59d47938196bf92d6ea4f665e0fe62eb5345486cc8e4c2"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a84f27a00898a54ea1606312f965f28f18fc6ed0c432de932f34493e4e210366"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "203eaa7da0cd79edddaefa4bc6ef38323f5da7c7d1dec2addc31843317d9dd0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "67b33885eb47882488210a98b69718e97ca7bb84eeb8c0a3a7db467b2f41f91c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf2198a3b0bfcbe654d0797c8f06aeec37060c08035942477e2a57e6c12adb1f"
    sha256 cellar: :any_skip_relocation, sonoma:         "b123e043ada873e376321d8023a2648d194dc5947455878518cdfe1e03a2b9c7"
    sha256 cellar: :any_skip_relocation, ventura:        "507d5ab304d9cb83e8a7bc418f6568f0e651bcb191e8064a279756820eefb56f"
    sha256 cellar: :any_skip_relocation, monterey:       "0b489956f7a2d3a265a0827f45a746d06b639bbefd3cb2a2d59c16464e9b9a69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "884fc0f8eebf88b9f8722638ff3593371795d14cad8d9cd289682ee9a61c0ce7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]

    system "go", "build", "-mod=readonly", *std_go_args(ldflags:), ".cmdconvox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}convox login -t invalid localhost 2>&1", 1)
  end
end