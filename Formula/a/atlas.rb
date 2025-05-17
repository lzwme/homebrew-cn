class Atlas < Formula
  desc "Database toolkit"
  homepage "https:atlasgo.io"
  # Upstream may not mark patch releases as latest on GitHub; it is fine to ship them.
  # See https:github.comarigaatlasissues1090#issuecomment-1225258408
  url "https:github.comarigaatlasarchiverefstagsv0.33.1.tar.gz"
  sha256 "97fcaca965d7c49a5290d1bb84aaa996c8ca1d542b557e865952aa5c8bf94baf"
  license "Apache-2.0"
  head "https:github.comarigaatlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f48886f3bee32fe67cae71046aa82d4026681bbead5d82f89a7d11788020bbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a91874d0a14afb9d5b114c5e2b02fea1c719d53f63e080fc90a65d05442a9937"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ab73688079844b1bd166c16f54841e92a05299ef2f5512c47ea3b6ae7b94d39e"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0ce67df47a985c69b43e36b16e028f5ff595a277eb42b8b17ad4c08d8619de3"
    sha256 cellar: :any_skip_relocation, ventura:       "33e932d97372475496bc81386ec434502f5bf16b5062a9ad49c8a5829de0d5d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4672250f2f934cb0d0a761c971ca310f136ce6bdbf70eb3d4b95773fc716e192"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e5dacf4d96c30b7294f167063de2f92f0f0d0a57349b931865a18249256e5e9"
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