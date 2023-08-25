class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  url "https://ghproxy.com/https://github.com/ariga/atlas/archive/v0.13.2.tar.gz"
  sha256 "1fb1a17761e5edaac83fdabbca2deea65371bc19c3281cdea6e4d3bea165d8d6"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c80bf0eb9d114ea19920bf1f09d387971baeafd929ec60597ce7b4fa70cddc46"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4cda0b1ee6ed2abd5df5ba4f78db0228802bb7d954367367ed5d37f9b25e9f8f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d3e3a1ff022ac08bfcdd7567e28f69bbd6a6186c007034ffbecca4d4cb35541a"
    sha256 cellar: :any_skip_relocation, ventura:        "203950b182d91fb924b85fab4c6988933fc4283d3e2e59bef4b6f0981053ae34"
    sha256 cellar: :any_skip_relocation, monterey:       "faf779c635dca5cb86c5330abe22649f0553b399443e71f0b9f8521efe8b8080"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd971d552c756afa10454b2723a220165f48e8ba16ea5a984fbbfbe0d67095b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01cd1abcd02b7738bf8c7ad031faca6468efe862eb1c91ab90f1c446f3bda2d5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X ariga.io/atlas/cmd/atlas/internal/cmdapi.version=v#{version}
    ]
    cd "./cmd/atlas" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    generate_completions_from_executable(bin/"atlas", "completion")
  end

  test do
    assert_match "Error: mysql: query system variables:",
      shell_output("#{bin}/atlas schema inspect -u \"mysql://user:pass@localhost:3306/dbname\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/atlas version")
  end
end