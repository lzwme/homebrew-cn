class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https://github.com/golang/tools/tree/master/gopls"
  url "https://ghproxy.com/https://github.com/golang/tools/archive/refs/tags/gopls/v0.14.2.tar.gz"
  sha256 "5a4939e08adf4de0720042868b43405de0cf221ae9a0b266694d4f222b3edfbb"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{^(?:gopls/)?v?(\d+(?:\.\d+)+)$}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6b96d6ffe25562a568317867bad6b40eb49a2b6d96f6eac4ebbbdaa146a580d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8eb7f4d3f6c64324457bdea49864a56ad968527cfd359d80622b8cd642bbefc6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c9cf8d627883d8a372fada9e205f31fe425501234bd07d2051c0f9d132a29cc"
    sha256 cellar: :any_skip_relocation, sonoma:         "ecdca58eb41d4f14afe40c19ca4da585d850dd7e75cf45e13898c40800fb7aa2"
    sha256 cellar: :any_skip_relocation, ventura:        "3a0d05d241c3d604e4bfbea3099c4b5306d2ce05b2a23bb78d88f5ab787bc6c9"
    sha256 cellar: :any_skip_relocation, monterey:       "8763ed3174af067f40f381ac6b2e9c85e0c0d93d393eb47fb00faf323ac6d4b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2811ead35cfe05253e551c082537f2e6fdc8412bb5f8eb35879ea44c5755c9a5"
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