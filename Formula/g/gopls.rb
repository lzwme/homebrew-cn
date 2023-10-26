class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https://github.com/golang/tools/tree/master/gopls"
  url "https://ghproxy.com/https://github.com/golang/tools/archive/refs/tags/gopls/v0.14.0.tar.gz"
  sha256 "a0705600556f09f52a4dc6ddca44a84b9ff626690e5ce8d49dc9c06ebc8425be"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{^(?:gopls/)?v?(\d+(?:\.\d+)+)$}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "efc844b121282e9a293c16b44bc7281643ad1fecbc9e34c67dbc3ebe0756f5ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "761b9f357e6106c5a68b15a1d3932e8af73ce153d2c4e03b961d13ddac49a25c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5f33b682d8610e254caa5cebc7203a104598a8ff2a83a6bd9e52cfb8a605834"
    sha256 cellar: :any_skip_relocation, sonoma:         "efcdaa81f23c2ad94e08dfd8fd0590cff5f0b7f7a6f0835326a603c8244c0832"
    sha256 cellar: :any_skip_relocation, ventura:        "3d3dcf9f32090e557ffa6011a5958b751bbdb2f122a20a4be6f0304982a45137"
    sha256 cellar: :any_skip_relocation, monterey:       "09181cd81feebcdc3e93af14ee84d085f897e183a19d00aa202c489058820e15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38593619035a43111ce992d0d1ddc184e2f3b9165d92a451057f7bc60d9d4588"
  end

  depends_on "go" => :build

  def install
    cd "gopls" do
      system "go", "build", *std_go_args
    end
  end

  test do
    output = shell_output("#{bin}/gopls api-json")
    output = JSON.parse(output)

    assert_equal "gopls.add_dependency", output["Commands"][0]["Command"]
    assert_equal "buildFlags", output["Options"]["User"][0]["Name"]
  end
end