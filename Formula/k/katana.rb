class Katana < Formula
  desc "Crawling and spidering framework"
  homepage "https://github.com/projectdiscovery/katana"
  url "https://ghfast.top/https://github.com/projectdiscovery/katana/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "07f102a34843c4123f7be9b6b6ab2cca93d1caeb6069106fb197396784584303"
  license "MIT"
  head "https://github.com/projectdiscovery/katana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "583dcc9b02bdb52e9069067bb09598d2ffdf4128133712e1f82f82ba3e511b06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a07fe41c3be51ab3838d966bbc0af57676a71d4103e71a9e6992ef863fc403cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8db74058d04691413d98b66b71f02680f8c144a5f992dd41c0d143e5292df562"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d9c0576c930076a7091393eb9a993ada444a6f26b240ae1fd5f848dbcf3216c"
    sha256 cellar: :any_skip_relocation, ventura:       "c70d15a91fd1d7a14e90944f8608e3261751f050815d7d73705afee8daedc1ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e790ba9287d65d3f17a0d4decc337a8412810e9825aafb7b4dac32a94f1e0bcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a959c38ca9ef52064a01a5043d6dc3d8d1697a01a7341bafe7fa45155fcc8a0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/katana"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/katana -version 2>&1")
    assert_match "Started standard crawling", shell_output("#{bin}/katana -u 127.0.0.1 2>&1")
  end
end