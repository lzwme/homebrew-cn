class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.58.5.tar.gz"
  sha256 "4ea122e0bb33e7cd553a6814a6b1ac1e0cd69a874633fc6b694d09834a0f0f2d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "66a9ad1f158a720458de0ca51757a9a131b7bff46845f090197b82c5493cef9b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d4c7b57b3d3dee4b8c89ced8b093fdf732172d245a592936aba06aef2b552eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8419445ac8e6eda9a96ad46994e9d3369e6d406eea74b78a7f36401eddfc3c13"
    sha256 cellar: :any_skip_relocation, sonoma:         "75ec147b61a39e93fa30d620ff804df9f17aebdb8c3e8ac64a33de02397d5e3c"
    sha256 cellar: :any_skip_relocation, ventura:        "315203731f6e7ccd800cae35abc723e93f1745d96dcf8f1a17d0723ef24d28de"
    sha256 cellar: :any_skip_relocation, monterey:       "f2ac1db0cbd96a11b64be0dc09317195730b79bc387f683e7785958195c426db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3a9daab9b9ff7e7d2b8d24d4153aa1364af3905f5e85755a458a3feeb67d135"
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