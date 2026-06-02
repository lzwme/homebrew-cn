class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  # Upstream may not mark patch releases as latest on GitHub; it is fine to ship them.
  # See https://github.com/ariga/atlas/issues/1090#issuecomment-1225258408
  url "https://ghfast.top/https://github.com/ariga/atlas/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "46c567ac2178d165e41aca96ca8900662a69f82d2c2729bbf442c3022c127cc1"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "72569a71ecf9d9af2c8f2b47b5eafbc951dfbc8300344cc5cc9695ab36d9287c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36b54bc9617e93d118cdc0c059d35664525581373ac2831f6c857c2b50089475"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c496f9008782e4346c824862b554b92f632adfc0442c78cbd568de417578f65"
    sha256 cellar: :any_skip_relocation, sonoma:        "30c7e56635196a7f3c93bbf2abf7d75f6a42d6bd01b2b3dfd40d3b3f72ed2392"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d319c6d301fed616407d9381e1a83a14e1130bae14867365026d1d6179d9b7e"
    sha256 cellar: :any,                 x86_64_linux:  "dfbb6c30cf12d681c14a94c94b0e7c960ee54d67fa9e342bd54390684a896911"
  end

  depends_on "go" => :build

  conflicts_with "mongodb-atlas-cli", "nim", because: "both install `atlas` executable"

  def install
    ldflags = %W[
      -s -w
      -X ariga.io/atlas/cmd/atlas/internal/cmdapi.version=v#{version}
    ]
    cd "./cmd/atlas" do
      system "go", "build", *std_go_args(ldflags:)
    end

    generate_completions_from_executable(bin/"atlas", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Error: mysql: query system variables:",
      shell_output("#{bin}/atlas schema inspect -u \"mysql://user:pass@localhost:3306/dbname\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/atlas version")
  end
end