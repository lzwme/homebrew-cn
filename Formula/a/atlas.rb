class Atlas < Formula
  desc "Database toolkit"
  homepage "https:atlasgo.io"
  # Upstream may not mark patch releases as latest on GitHub; it is fine to ship them.
  # See https:github.comarigaatlasissues1090#issuecomment-1225258408
  url "https:github.comarigaatlasarchiverefstagsv0.29.1.tar.gz"
  sha256 "db5972f826761c9f52cb968061dd50d654e1b63af35bd81c01eb1218dabce924"
  license "Apache-2.0"
  head "https:github.comarigaatlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce06499f6f994251d00749cd656d932caa408e473884b357d8c961146576f2ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4750cdf5afcc27f43ae05d5d44001e268b581234cc206fda6d74e89772fee9e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "343bd34238cd54a4ca7a86210a9e0cf16c7e08eae0c044e73a84e15c185acfe6"
    sha256 cellar: :any_skip_relocation, sonoma:        "94aa90d335a47cd1eb6bd674f8f6cc485054826476e99f7db2c61ccbc6f9cdce"
    sha256 cellar: :any_skip_relocation, ventura:       "b9b18c465b07e6ca6917549fa322b4319e1a9a84dcd757b829429d2f45a5964e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f807164d6f65aa72776487062b21a00b68f97b83529a45f6ff07f5f363980f6"
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