class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://ghfast.top/https://github.com/block/goose/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "dc3cdebca1cc48909eed95124476d22d14f2ea081445cd11c86c2af23949948b"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be2b628aa8cbff64f57e47b35091dbb9712b5a5016da1d830641f05309533886"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82f2ee8c725a15cfc74f2fb8e2dbb10109445421ff9a9ad9de73baf2a3a5c41a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2397fe52a9c6cb95b49bc602753891753aba9ce67a23cb505fa52085c080b002"
    sha256 cellar: :any_skip_relocation, sonoma:        "c95372393ec0fb4c200777c385e85c92377294e5cc1ede3508fa1138bba2591b"
    sha256 cellar: :any_skip_relocation, ventura:       "6f38478a7feb47f50649ac286af99a3ceb16d5f75cdb7de9f22fc3e4026a5b7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "764a24e5e8659c0fd9923a6e495183a982443d780e06a7aeb740a2daf63d3b48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd36fbae2f02d609012d1477859d909aea9cdf8cba70693692f9a5061cf1d500"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build # for lance-encoding
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "dbus"
    depends_on "libxcb"
  end

  conflicts_with "goose", because: "both install `goose` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/goose-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goose --version")
    assert_match "Goose Locations", shell_output("#{bin}/goose info")
  end
end