class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.55.5.tar.gz"
  sha256 "29d1c7542b63228275463b608ca8dee980a26e47598c12d0d3195912dad21f4c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5ea38a3b14a6fec17933e64625a956c2fab4ed1b5271b009258d2c1ed9f1175a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "918e96e10e1839d75e4510571da4ca50d7443e4f26cee18e4a832b1a64b0a8e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19161fcf876bdbf2355803ab2de802e60025445a98b136942cc0e990e9e092b4"
    sha256 cellar: :any_skip_relocation, sonoma:         "070e7ae2b5096ab8741cb87154e3e88229c75f6d4bb12ccee92a73488c118ed3"
    sha256 cellar: :any_skip_relocation, ventura:        "3ee092636e8f318b48f33cf0ec1b77557fb5ab2cdb301b1c8c5a352785d6e368"
    sha256 cellar: :any_skip_relocation, monterey:       "3829edacdfc27a100bc79ab3bffb004e592ee82130963f63549eefe0bd816a7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad6a97238f9ad90e31190c0d0cdaf9ed63553a8d17100691523fc4b77cb23bd8"
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