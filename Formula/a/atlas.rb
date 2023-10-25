class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  # Upstream may not mark patch releases as latest on GitHub; it is fine to ship them.
  # See https://github.com/ariga/atlas/issues/1090#issuecomment-1225258408
  url "https://ghproxy.com/https://github.com/ariga/atlas/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "ee8ed6f61abd0e4ba0ea2e0db72f90b6eabc0bdcb318d589d17c7c2c80412d67"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8a8707fc24d3da7b787e21fac6e937ac941d789d66cf6c477bd43b1ef15b9789"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fea287a299544ab84f5ac7eda7567a8eb661f0c2d2c91766b6ca1eb44c29c972"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6bf942af6800181224f3fe7a0c7a49c2b94d8ff53a088206ea68974076e8c23"
    sha256 cellar: :any_skip_relocation, sonoma:         "67067e0db606b944e5b1c4c480ec8edef6b1501128aa77452db3433b9be9c5ea"
    sha256 cellar: :any_skip_relocation, ventura:        "b68d9ff8ac231d03217dd6385df54d5c304da643d9ff43dfb280817e4024eb20"
    sha256 cellar: :any_skip_relocation, monterey:       "bd0cbf6fbfe78c9cf39b0735ca3034f5b324c917da35817b1fbf48be7611c1d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3917a9ed043e7d5b48daf7ef8a706cec5c9298831eb3573a5961dac173d3ab0c"
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