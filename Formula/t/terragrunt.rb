class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.58.13.tar.gz"
  sha256 "2949ebcd20461dcaa8ffafbc83bd59d654caf1fd9bc0ac7e0389e50d19b5346a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5f883ae30c7b0041daec5f872e21d3bd2a4bd6affda7f29e30125c4a5ca31ded"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b0a0242746317da9a36c329a4b942307fea30f27c627bf7a49a5c72bddb13a63"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b22d0ed6964937fe8add47a4ca43cd516d72307ed60cb9d3cac2904f23e3c98"
    sha256 cellar: :any_skip_relocation, sonoma:         "c320f83d972a6d1bdd1300ff15f22137d2b2a3577a270d82a3b968850879b228"
    sha256 cellar: :any_skip_relocation, ventura:        "989f1c63d86b6f535632fc106be0c17fd0b93d133caa43dda2c6da8b5af9ec05"
    sha256 cellar: :any_skip_relocation, monterey:       "7fda8092d4cd232a0051f2a6ea3ff8415e8982725e25ea1848c45eef5cc81b5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad379ff6f67710aa763ba987a7312fca69fa450e026ad371320ca6e1dc216d47"
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