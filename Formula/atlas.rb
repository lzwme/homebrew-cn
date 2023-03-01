class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  url "https://ghproxy.com/https://github.com/ariga/atlas/archive/v0.9.1.tar.gz"
  sha256 "de09659d7af004e4642be8391a237248f4c0b5e1db7e25d464aecae97b7aefe7"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a78492f448316a4812a31fab420d034c54e0ad001abfc2d945c675ce0f83f8f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20fdc5afa49f9104d3e04e11c155718a1e0c3ebbb9ce55620f1dce92d98b596f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d27c720583f7816645806696ebdd18bcc8ab73e1a531cc9cef434e4357859985"
    sha256 cellar: :any_skip_relocation, ventura:        "a9f48b6bf453e025f141c322ca506cb1b8fb69a8180cc3c4974d9c863f766358"
    sha256 cellar: :any_skip_relocation, monterey:       "a6ec2af6e34ac7dcc35b3857233bef7e3791adadd55d732f6a2a0acb71e8d50a"
    sha256 cellar: :any_skip_relocation, big_sur:        "020f67d492bb655d0303cbe39329282e16c00889e4714f6fcb2aa5fe35f3fa3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b683944755a688921a95a16d5470c03ce4e94811ca1c2688b148621f21ecf932"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X ariga.io/atlas/cmd/atlas/internal/cmdapi.version=v#{version}
    ]
    cd "./cmd/atlas" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    generate_completions_from_executable(bin/"atlas", "completion")
  end

  test do
    assert_match "Error: mysql: query system variables:",
      shell_output("#{bin}/atlas schema inspect -u \"mysql://user:pass@localhost:3306/dbname\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/atlas version")
  end
end