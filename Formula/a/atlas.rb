class Atlas < Formula
  desc "Database toolkit"
  homepage "https:atlasgo.io"
  # Upstream may not mark patch releases as latest on GitHub; it is fine to ship them.
  # See https:github.comarigaatlasissues1090#issuecomment-1225258408
  url "https:github.comarigaatlasarchiverefstagsv0.29.0.tar.gz"
  sha256 "de0746273e3c06977230ac074f9104af697e582ff8a80b533c325930244d5ace"
  license "Apache-2.0"
  head "https:github.comarigaatlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17d58cffdbe423c2e3fce90b1d99fab1b33e248f8d8b0ba659178c6b654257cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "240f1b5f4524065b80dd7deba7f4cea8bdcf5d8d6edab534ed1dc22b1282af28"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "40945a87e4d7c3b02cb32ba551089d78bf4943a3d48e20606cc923b9f19abd84"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f550303485375d448f8ffda3d6733c1066d75c3fd7db848016c8758d557edeb"
    sha256 cellar: :any_skip_relocation, ventura:       "8262104b5a12db1391c1d8071408d99b1819689de7ad1c4ef0c19c227c7fe0bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5b16e1fb0a088cedc2c13669194ce2ed3fd395e9f8038316a41fcc18768c171"
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