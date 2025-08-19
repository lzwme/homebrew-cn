class Oj < Formula
  desc "JSON parser and visualization tool"
  homepage "https://github.com/ohler55/ojg"
  url "https://ghfast.top/https://github.com/ohler55/ojg/archive/refs/tags/v1.26.9.tar.gz"
  sha256 "fe015c3838dfe1b80abc4b7d122317c384fefd83fd1ed6743b90e61975825fd9"
  license "MIT"
  head "https://github.com/ohler55/ojg.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "904bf57292314d10983949ff1406e8c13a4f32e4755ff14d40577ab237640251"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "904bf57292314d10983949ff1406e8c13a4f32e4755ff14d40577ab237640251"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "904bf57292314d10983949ff1406e8c13a4f32e4755ff14d40577ab237640251"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f0aa6a27e4c44974e6e7d603f8f9a48b41c215d375225081725d00f68be0da7"
    sha256 cellar: :any_skip_relocation, ventura:       "3f0aa6a27e4c44974e6e7d603f8f9a48b41c215d375225081725d00f68be0da7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "634811aee33afdb780b3640d70ada116edaf4ae708a5e8c43a7d770e24501c3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f74480e688e6f1e5b0657a3741323b63e601cdd0bf074e1985d5b8bf9392f878"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=v#{version}"), "./cmd/oj"
  end

  test do
    assert_equal "1\n", pipe_output("#{bin}/oj -z @.x", "{x:1,y:2}")
  end
end