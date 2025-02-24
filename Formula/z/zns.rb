class Zns < Formula
  desc "CLI tool for querying DNS records with readable, colored output"
  homepage "https:github.comznsclizns"
  url "https:github.comznscliznsarchiverefstagsv0.2.0.tar.gz"
  sha256 "4a54ccbc0d2d027ea6a56ccef0f3b40c284cc2ad014467181dc2c7c74641314d"
  license "MIT"
  head "https:github.comznsclizns.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c77a27a8771587f16fb718f16b4685037d8860f0ba6a2c2851f42d8a999131f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c77a27a8771587f16fb718f16b4685037d8860f0ba6a2c2851f42d8a999131f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c77a27a8771587f16fb718f16b4685037d8860f0ba6a2c2851f42d8a999131f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8a96e4b0379acb1d3e38a7345147b2738bac2a37a6ff10819a5d2335faaaba3"
    sha256 cellar: :any_skip_relocation, ventura:       "f8a96e4b0379acb1d3e38a7345147b2738bac2a37a6ff10819a5d2335faaaba3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e33a19b79bf18eb61ddc8ae3d9baa512b3cf6f70d679fcdba27095f97baeeb8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comznscliznscmd.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}zns --version")
    assert_match "a.iana-servers.net.", shell_output("#{bin}zns example.com -q NS --server 1.1.1.1")
  end
end