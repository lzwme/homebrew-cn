class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://github.com/iximiuz/labctl"
  url "https://ghfast.top/https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.83.tar.gz"
  sha256 "6ed9874b59c3c11c9d079a9aa7b1e56f214ab9c2c5f52136977e455faa77b1d1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07fe28e1e1444d529f401311ddaa6310e687710c4755ed493793ef09c93db5c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07fe28e1e1444d529f401311ddaa6310e687710c4755ed493793ef09c93db5c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07fe28e1e1444d529f401311ddaa6310e687710c4755ed493793ef09c93db5c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "cee6d17ba570d43ba9ca400e301ae98d374415b0c7d2a4a6129343f09d17eb30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e74ddd8802bbd19f992aadff5edeb57ed8938aa82e855cfb003747fb69f9c00b"
    sha256 cellar: :any,                 x86_64_linux:  "fd79cc656c09f86bf0c504fb373eb70ebb5ce613adf80a27abeca20f5d7f3877"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/labctl --version")

    assert_match "Not logged in.", shell_output("#{bin}/labctl auth whoami 2>&1")
    assert_match "authentication required.", shell_output("#{bin}/labctl playground list 2>&1", 1)
  end
end