class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https://github.com/golang/tools/tree/master/gopls"
  url "https://ghproxy.com/https://github.com/golang/tools/archive/refs/tags/gopls/v0.14.1.tar.gz"
  sha256 "33f886f65268c6b1e3e3a0177681c2aeaeba3993b2a0829d18efb49869c1ca0e"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{^(?:gopls/)?v?(\d+(?:\.\d+)+)$}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ad13d7484f1b89bfed3c06934e2727154a09d9a0a3eb1efa9ad3d08a691d4a65"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2c84bdd825cd4f7788733778b9d35e9391c744bb46a6d434226e256c405cb3b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f03b258b74dd9e1ebe49d248b53cc4ed6213dd083825b3e85e8d189c671a14e3"
    sha256 cellar: :any_skip_relocation, sonoma:         "ca1521a7632d48454069ed0b23ddf644382791bd4cfb5cec38e4f9e8f87fcbaf"
    sha256 cellar: :any_skip_relocation, ventura:        "faaf17b76b325928f4bb20ab4d63348022a4c0d7086cb5a42cd289bdc7ab5cea"
    sha256 cellar: :any_skip_relocation, monterey:       "caac251de95f8bf8e6479d6f6074ab8171b162f47b9299f215249cb5fd2efe9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "699104608413ed5df44bad164e902935841d5d23b69eccc662ae016efe280274"
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