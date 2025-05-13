class Atlas < Formula
  desc "Database toolkit"
  homepage "https:atlasgo.io"
  # Upstream may not mark patch releases as latest on GitHub; it is fine to ship them.
  # See https:github.comarigaatlasissues1090#issuecomment-1225258408
  url "https:github.comarigaatlasarchiverefstagsv0.33.0.tar.gz"
  sha256 "abec6e325122e4ad3c8df75b71265de56a584f30126650b3d976cdb1976fd736"
  license "Apache-2.0"
  head "https:github.comarigaatlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fec845948808c427e76400861c96b081e073c22261f0276c71703cfa3df5275a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3737fc1be1e2d01e9231ede75345cf4c29c43bda88017229a95b039a7af66682"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6287e20d6a36f742a98f659ef00f09b471c9b5804c81c02cdef22a2009a575f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ca3ea148c2f93590fbea6873f824bb5feaafe16a8a7875d5840d6e3dc67c17b"
    sha256 cellar: :any_skip_relocation, ventura:       "cf9b4b67fa8561ddd40eadc48b7cbeca4dfb85fa5b5ecc7d0c1b12a07fb475bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37f7fc55f7e070019e2b178e233d467658c373f16d4e5393d267c079fe3a2bdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42a7fe502963f23f059c2e1c2458a118cbaea7edbf4b196d0257914185abed78"
  end

  depends_on "go" => :build

  conflicts_with "mongodb-atlas-cli", "nim", because: "both install `atlas` executable"

  def install
    ldflags = %W[
      -s -w
      -X ariga.ioatlascmdatlasinternalcmdapi.version=v#{version}
    ]
    cd ".cmdatlas" do
      system "go", "build", *std_go_args(ldflags:)
    end

    generate_completions_from_executable(bin"atlas", "completion")
  end

  test do
    assert_match "Error: mysql: query system variables:",
      shell_output("#{bin}atlas schema inspect -u \"mysql:user:pass@localhost:3306dbname\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}atlas version")
  end
end