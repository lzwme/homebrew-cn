class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  url "https://ghproxy.com/https://github.com/ariga/atlas/archive/v0.13.0.tar.gz"
  sha256 "aaef588414da85d910d47ef206e3b1596cfc15abdad6473712476f701fe4f932"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "98d05b945986f600e12a4da0b75854ff255395b8685bda03bd8824f69ddeb957"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "504e25f82b43a039f8945cb7d777104485597b00a342b1715a65ed50c4a497bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "471eaf549d96e2aad2d7d9e5ec516ec4cb5053b4e650ebe979c5f9ea9b98e36a"
    sha256 cellar: :any_skip_relocation, ventura:        "d011fc9c8ff3ae4a5fcddf73cff8ff8f47b207be03f86a6ee24f8a85d4261114"
    sha256 cellar: :any_skip_relocation, monterey:       "e36fceb718439e0d289dae9d6e36fd6e0dfda75396688c15cdeef4a834ef896f"
    sha256 cellar: :any_skip_relocation, big_sur:        "a4df5e958bc5bd7a6ace14f01b3faf2c1f58175b9cd85f6024e3ad19959acf9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99aa165a261ee347dc913a7308285284594cf01da3b6bcce80aa1fd8faea7fa8"
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