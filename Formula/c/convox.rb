class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https:convox.com"
  url "https:github.comconvoxconvoxarchiverefstags3.18.4.tar.gz"
  sha256 "1a0fe26309ce767249b27d88b98688143044c634cf71af9b7815914113617eed"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "20846bf361e43e240ace11abe97838288c57802c861e57eb0bf2356b624a8c04"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f8fdb0962a762acb76f2722eb7006f82438db220460f3a99aee63710f025adf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43099228912a52d73259d7c51eba734186dbf1cdb07a73b397743e1a2873bdbe"
    sha256 cellar: :any_skip_relocation, sonoma:         "65e94eaef59b57e9ee64050242032afdc61f5fc2ca21df7b7eb85ce4972b5b1f"
    sha256 cellar: :any_skip_relocation, ventura:        "fba0694ddbfb7cb5ca1037d575e5b6d6773fdb70992e5a135a1add7eb9af043d"
    sha256 cellar: :any_skip_relocation, monterey:       "a2303f39ecdc01c042f54cde037259630cae690b769bff9b52c6714283c6294c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffed351767ba42f1a31ad9fa7f7bb593bfeb9abac5b66bbc6e7fc0c4a88bc6ec"
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