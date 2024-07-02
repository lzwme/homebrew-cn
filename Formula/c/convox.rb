class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https:convox.com"
  url "https:github.comconvoxconvoxarchiverefstags3.18.6.tar.gz"
  sha256 "1318d20593c3608e6f6ab95ff6192f73f2be60315bacfb3ad4df46062fe34eee"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c7bc7e128d3e1d93a64a4fda41fbd168218e615eac339a3c11febf93b1c34fd1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44ebcb5a6befe3f7272d02208d3f6b6a89d27c25349285610132108ce59243e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4225a2e1e5d2b3f2c180c9fd3dfd8265133a58ec4b55bf490ad6f91d8269be30"
    sha256 cellar: :any_skip_relocation, sonoma:         "078aca570f61c0576b5d564646789970782a54fff85e684086bf5774c32edc25"
    sha256 cellar: :any_skip_relocation, ventura:        "5f4ec190fdf63dd68de972bd6a7e32c18024ed885a3b828f63ad2b6126ca6050"
    sha256 cellar: :any_skip_relocation, monterey:       "f592d05428e11512cbf4035acc7691ce5623bb166c43a57ef27014eeb8251a6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "755950b94542b893324a0b3b34c293dfe7b614c454f829ddf91d5fbf778cb05b"
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