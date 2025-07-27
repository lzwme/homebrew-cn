class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  # Upstream may not mark patch releases as latest on GitHub; it is fine to ship them.
  # See https://github.com/ariga/atlas/issues/1090#issuecomment-1225258408
  url "https://ghfast.top/https://github.com/ariga/atlas/archive/refs/tags/v0.36.1.tar.gz"
  sha256 "632a08a22b0b2be71e48eca10c8a67d6e72d21023cf3eea2673373c6a7c68055"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d25a049d58fa0d0a77e821a987b1693a067f8635038483a55581a5a73ab591d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18d7e3f3442f36583fc4360304f866d02e37f85795ebbc76bbffac46fb9dd52d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "180d80f3ba8cff9a61406e9fa42f83a0cd6c4e79f262e46fc110e13075937dd8"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa4cdd80eb8d5f476d37cadf59e628a19a28b8dcb22af6440a945ce970089564"
    sha256 cellar: :any_skip_relocation, ventura:       "a97a61cd0330d1d24e238744a2e85c4cd95b26ece285ffd148618f5fa2463847"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6deb94fdf8b297fc980c0424f347472d4f4bbbd6ec3a1b7e7d0b652e9b53d60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aefc33ab37894dd5e0f086ead0832c8af76f4e2e392490e23da423ade9c2cec6"
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

    generate_completions_from_executable(bin/"atlas", "completion")
  end

  test do
    assert_match "Error: mysql: query system variables:",
      shell_output("#{bin}/atlas schema inspect -u \"mysql://user:pass@localhost:3306/dbname\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/atlas version")
  end
end