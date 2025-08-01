class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https://github.com/golang/tools/tree/master/gopls"
  url "https://ghfast.top/https://github.com/golang/tools/archive/refs/tags/gopls/v0.20.0.tar.gz"
  sha256 "1ff2a83be8be5a61b97fc5d72eab66f368ec20b52c513cc6656fc2e502e46f19"
  license "BSD-3-Clause"
  head "https://github.com/golang/tools.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^(?:gopls/)?v?(\d+(?:\.\d+)+)$}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc404c5c044916bcaf735ee34c124a6d09d0537294a16d6c2249a925518a7973"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc404c5c044916bcaf735ee34c124a6d09d0537294a16d6c2249a925518a7973"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fc404c5c044916bcaf735ee34c124a6d09d0537294a16d6c2249a925518a7973"
    sha256 cellar: :any_skip_relocation, sonoma:        "00c0f74e4d28da481f4516ff0b575dbbda08a5943993907da714db0f93108166"
    sha256 cellar: :any_skip_relocation, ventura:       "00c0f74e4d28da481f4516ff0b575dbbda08a5943993907da714db0f93108166"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca0d727d3748fea8756d7212552060bf2df0373e9558fc149ec3956ff2446bd6"
  end

  depends_on "go" => :build

  def install
    cd "gopls" do
      system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=v#{version}")
    end
  end

  test do
    output = shell_output("#{bin}/gopls api-json")
    output = JSON.parse(output)

    assert_equal "buildFlags", output["Options"]["User"][0]["Name"]
    assert_equal "Go", output["Lenses"][0]["FileType"]
    assert_match version.to_s, shell_output("#{bin}/gopls version")
  end
end