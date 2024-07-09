class Feishu2md < Formula
  desc "Convert feishularksuite documents to markdown"
  homepage "https:github.comWsinefeishu2md"
  url "https:github.comWsinefeishu2mdarchiverefstagsv2.3.0.tar.gz"
  sha256 "b8ba4ce9ed3e8ff82e311e28c7753c0185f86b0f1c2c066e51912cf51b8b2e88"
  license "MIT"
  head "https:github.comWsinefeishu2md.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9d71cfd2ba94c21b84f47ccc1e573e821ca532141c6b1c1d3dd89ea1d2542ad7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc0bd07cbb0ce4e04186eb53e76a8a7bed31c57b9202729c6a6be432cee7baa0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42de37a0901d9d8a364f37a2b31606c080409b60fe25ab2bef358f9c46cac340"
    sha256 cellar: :any_skip_relocation, sonoma:         "82bab61994eb59ba4e9221657742f835b9b6c3407e2598209bb876aaf60c5a2c"
    sha256 cellar: :any_skip_relocation, ventura:        "e5ad5944a4b5245742aecea038fc7c16bef79339927e9f18b9f76ce60cb0e8d4"
    sha256 cellar: :any_skip_relocation, monterey:       "17511284a9b654cc21d85c09f792756afee8ca0dc0e543f85efbb5036356fb7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57cdbfee016f08bf0dd71a6d4eb32a2426ed27a3ae6207538d1772420dd494af"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmd"
  end

  test do
    output = shell_output("#{bin}feishu2md config --appId testAppId --appSecret testSecret")
    assert_match "testAppId", output

    assert_match version.to_s, shell_output("#{bin}feishu2md --version")
  end
end