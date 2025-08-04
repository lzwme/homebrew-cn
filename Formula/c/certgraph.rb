class Certgraph < Formula
  desc "Crawl the graph of certificate Alternate Names"
  homepage "https://github.com/lanrat/certgraph"
  url "https://ghfast.top/https://github.com/lanrat/certgraph/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "2749ee2fa102019e847e316b1cbb25d7cd5cd8b5e49969cef290972019187452"
  license "GPL-2.0-or-later"
  version_scheme 1
  head "https://github.com/lanrat/certgraph.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bde0c1f8afd2b9c5958c78a25a40e7e992557ede0ca00c0330fa0484635eda6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bde0c1f8afd2b9c5958c78a25a40e7e992557ede0ca00c0330fa0484635eda6d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bde0c1f8afd2b9c5958c78a25a40e7e992557ede0ca00c0330fa0484635eda6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ed721de7ae895d61b262588fb5474616d535a494555d45ae4c16cf9e8e00aa3"
    sha256 cellar: :any_skip_relocation, ventura:       "9ed721de7ae895d61b262588fb5474616d535a494555d45ae4c16cf9e8e00aa3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a79040989ad70a9a969056413dace4e155218fc87d2e93eb70e816a8af1b43e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    output = shell_output("#{bin}/certgraph github.io")
    assert_match "githubusercontent.com", output
    assert_match "pages.github.com", output

    assert_match version.to_s, shell_output("#{bin}/certgraph --version")
  end
end