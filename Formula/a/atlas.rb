class Atlas < Formula
  desc "Database toolkit"
  homepage "https:atlasgo.io"
  # Upstream may not mark patch releases as latest on GitHub; it is fine to ship them.
  # See https:github.comarigaatlasissues1090#issuecomment-1225258408
  url "https:github.comarigaatlasarchiverefstagsv0.21.1.tar.gz"
  sha256 "eb35bf79613d1bba10df482cf688a0c5a139e8834f4ab65747cd2b63cbe610ae"
  license "Apache-2.0"
  head "https:github.comarigaatlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "97daf23a354a88f38b3c58a8155ab11db1fdaf6c881c7c4f346d4355e73e98e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c62527dcdc62d89dc62a4bf4c182d52c5e3bf5797bf669a44996d463c061f85"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70eb0df41746b48e018265ddd63dc0f8243395ec46747ce3fcdc5cd835d6c203"
    sha256 cellar: :any_skip_relocation, sonoma:         "707c378be54be23252910d584961ee31ff6b53aee5239037698b5fbfea329b38"
    sha256 cellar: :any_skip_relocation, ventura:        "0830fc0b0cf4ea2aac365c0e6cd5f9ee162d1ed9fbd249984fbb39ad2a396b0c"
    sha256 cellar: :any_skip_relocation, monterey:       "a1cbfd674468963df6837d53c182212e384b94b9ca6332398b4966269cc7ab90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "739d4adb5610e61147d1cedc1d679bf6d2d47fc984a50f954abc6612aa6e9ecc"
  end

  depends_on "go" => :build

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