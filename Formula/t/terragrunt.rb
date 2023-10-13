class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghproxy.com/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.52.2.tar.gz"
  sha256 "44e4f441d3d2d43ac624ef3baa7be357e70c76f7ef4e1f61500ae876d1fd018a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "75cfe808a0d53d025cfcef936c434f6176d3bf1fdd14e539840df850fc1213b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cfc06585444236fec30b3d2c657b97ee3e3d7de58c254dad972b346a5c94acf4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "368e6c4deaaeff9008a2fe5f108b4aeb63efa312866fca4e0a3507f5716f6a26"
    sha256 cellar: :any_skip_relocation, sonoma:         "b77147805f92d40195c1e64bb13ef53c718321722020d27500c8c8d8c43fb23d"
    sha256 cellar: :any_skip_relocation, ventura:        "cd86604c58f3529a0b2f22a5ffba4303b1745941a426dcf351ffa626c47c1ed8"
    sha256 cellar: :any_skip_relocation, monterey:       "2fb6e839de9c92a495ff2c625d922044264d7c9940425450052ec1833da48cb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2829435a58f56de6144bf985013c4a032d8a5cb5ba3f035f5c2c855085d992c9"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/gruntwork-io/go-commons/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end