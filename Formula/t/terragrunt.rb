class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.54.17.tar.gz"
  sha256 "02d98e941ed36c0a4e8fbbe7131dd4bc84897d304880fdc7aa94a17ae411794b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7ddec2ee92406f9e2ce56aad5b5439c1431a696dccf6bbe4910db7c6ec8d3b31"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f0a0d6e66a8c792a2c037d8dcc6fd8cf7af4d8d485535f69b9532270e489231"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88a03e156f91cbf222a9b853e924d1776477f791e7cc4cd24bea41e40fb731c7"
    sha256 cellar: :any_skip_relocation, sonoma:         "084251c7213b1f15dcdef9a30bcc95f32906369851f7b3cb593a674985b55b3a"
    sha256 cellar: :any_skip_relocation, ventura:        "2415f604a01318604bb8364d825d3db4b29046941dcabbf29c69792faab56207"
    sha256 cellar: :any_skip_relocation, monterey:       "72dae4ad39ba3b3d5cc4e992b5e200f49b38355d73a37cc82764f4db0d163cb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01e1d1124ce08b25ee3a7a0d5c495c2ce3f94651b1b745272c4db6b371c74350"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.comgruntwork-iogo-commonsversion.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}terragrunt --version")
  end
end