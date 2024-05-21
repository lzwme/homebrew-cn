class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.20.tar.gz"
  sha256 "bb86d8177a8a86946e26e750d8bd3db0b4802a570f5922590af8811dfbd82c06"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "723e45436be8af618b87fa37c66db9187615fb6fe7a2af7c714092a1cd0d47e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a643d48ea253b4e844b161e5765f9c155132e6bfb589b354b92010a05059166"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6024740a6b1fa7ba0a5f13dd7bd6fbe966ca9b49b284002f4e071fce5a993b62"
    sha256 cellar: :any_skip_relocation, sonoma:         "c74e37763c014ef832361d194403c46527c41820411d282f19c40fa2becd2bc5"
    sha256 cellar: :any_skip_relocation, ventura:        "7e095467a711b048049e09f0327fc72871d225971f78af467e55b1e7d31d1931"
    sha256 cellar: :any_skip_relocation, monterey:       "03626a9e50f458ada291c40c5ca01207244eb29730537eeebf06409ba2178c46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff8662d5040c6ef4f95410117b8b3b0d196f10636fe99c2053fc51925cfa4b23"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comnucleuscloudneosynccliinternalversion.gitVersion=#{version}
      -X github.comnucleuscloudneosynccliinternalversion.gitCommit=#{tap.user}
      -X github.comnucleuscloudneosynccliinternalversion.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".clicmdneosync"

    generate_completions_from_executable(bin"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}neosync connections list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}neosync --version")
  end
end