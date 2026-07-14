class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://ghfast.top/https://github.com/convox/convox/archive/refs/tags/3.25.0.tar.gz"
  sha256 "b2794ba0e926d92838748ebdc35b5c6f8aff55ab5de2d4ff9d40196da16edf3e"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/convox/convox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47770230a343224ba95170590160acf656dec46ddad84324ac2589dd08e33f7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d805a58c14a1832216e45485dc2a9e0fb4d70c9a5a8c33090e51f8f08fa280f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a93b8a37f5a91326954d5f883419488beb3cee507a44378c7190a25cb9be31f"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f4beb7225add5b71c3ce713b60f288f1f60ab7347fe8b99b4126139b1a3ed6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a15d4187634a9323a443527ef4597696756f96bc101a1cdba9914a2a40474eaf"
    sha256 cellar: :any,                 x86_64_linux:  "92d7d7c0c6a1b14b021d96dbae9d180ae0f6b67186b3bd9306012a231f2b61fd"
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