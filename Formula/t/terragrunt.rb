class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.58.2.tar.gz"
  sha256 "ea3e4c70bb393c00ca0995e13146d2dacdcbdbf74a210f309c469e41d0de743d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1388bfbbc51be77903ca2ae1a012d5cf11784405504730a92dbb814924bb62b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff6fd0d84f871dd11bb283564901bc6bfe24bdf58eb43a88d9f891336b6e8973"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "abdc9b3cad9642387eddff3305b0a4605f4e8448a2da84396935f8a56a7dd6fd"
    sha256 cellar: :any_skip_relocation, sonoma:         "b92f3b8cd5b68c6e92f4f92661d739e51d082892a804fa92ee37846463090962"
    sha256 cellar: :any_skip_relocation, ventura:        "22f09f8918211421c9cf5314ab1a67092a99b45698c81a37e54c0a545bf4c134"
    sha256 cellar: :any_skip_relocation, monterey:       "bf450d2c3351615aad9fb409efd5257804021161f286cb9b9d4a6a98b7162151"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d89acb20ed7b8bb6dd0fb93abf0f772f64bd1b3b920c4c436944c6ea8f4d9a43"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terragrunt binary"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.comgruntwork-iogo-commonsversion.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}terragrunt --version")
  end
end