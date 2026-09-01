class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https://github.com/projectdiscovery/httpx"
  url "https://ghfast.top/https://github.com/projectdiscovery/httpx/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "ff552a4a27d8dad1b4a796c27f72680db4f1149350a255cfd4197fee2159ab11"
  license "MIT"
  head "https://github.com/projectdiscovery/httpx.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8915648f5f388d443b7579ffaa7982909655848a010ff021454e8b4c3a4dd769"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81defa511713fce29cd6512f4e2790ea9c96a9546a738f01ff5842e410e29e35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a02b654cc9c42b601c5e037a80f85a93d3d2ce83bdfe2984a4549379d85acb60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4fc39403b5d10044151a777a00223d49e69ccde67fca9f174b400eda07e2a1fd"
    sha256 cellar: :any,                 x86_64_linux:  "13da0e1b578c398669d243e6711f7e479c87981ed5694e78d358e467e266d038"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/httpx"
  end

  test do
    output = JSON.parse(shell_output("#{bin}/httpx -silent -title -json -u example.org"))
    assert_equal 200, output["status_code"]
    assert_equal "Example Domain", output["title"]
  end
end