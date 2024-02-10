class Ignite < Formula
  desc "Build, launch, and maintain any crypto application with Ignite CLI"
  homepage "https:github.comignitecli"
  url "https:github.comignitecliarchiverefstagsv28.2.0.tar.gz"
  sha256 "556f953fd7f922354dea64e7b3dade5dd75b3f62ece93167e2ba126cac27602e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b3917626df2ccb9f2b33a2a4b06cf9a714697ebe927e6e3985460fdcdfdd2d38"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3858b0f9ff045eb91ef61511d63646517a9f6495cd95daa87179a2bbcc8bb63"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8e6352fcb7dc6f19cdb22f7180dd794cec4b85a73e8e18932ad15a37f5a1a70"
    sha256 cellar: :any_skip_relocation, sonoma:         "db880dd38b2702a7cbef4f1811f95ebf11bf5e6b75911fbd8cddd5992a58b3da"
    sha256 cellar: :any_skip_relocation, ventura:        "3c4eefafe9e58270fd9e3dbfc12747be0b5ff884855507bcfc5249b00a3d5dd0"
    sha256 cellar: :any_skip_relocation, monterey:       "8e6d27b8c589c420e3d238a1399354c033ae7f274fe251366277475be75bee73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a08f19683fa74772862d744a8677cda077f809b27fc2c4a5691fa89e2dae83ae"
  end

  depends_on "go"
  depends_on "node"

  def install
    system "go", "build", "-mod=readonly", *std_go_args(output: bin"ignite"), ".ignitecmdignite"
  end

  test do
    ENV["DO_NOT_TRACK"] = "1"
    system bin"ignite", "s", "chain", "mars"
    assert_predicate testpath"marsgo.mod", :exist?
  end
end