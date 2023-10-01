class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://github.com/kosli-dev/cli.git",
      tag:      "v2.6.8",
      revision: "741fef7326b4b4b47f5fc593231772a60932ca81"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f903df11f09f4aaf4eda5ec24504170681a017246347d88e08d1fa09e7b67f23"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "765be308a9a2ea671709d1fa4c4a367da03e9720765d9e779f9328a94b65152f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16cd6d5c1f08346c0e5104fcb773f82732cd1fb95f026cbfc29374de7e31cfcd"
    sha256 cellar: :any_skip_relocation, sonoma:         "8eb7eeba1c134c9bf0a90d1973794f45a1196b72d40f2658a08fa53fb13a08a0"
    sha256 cellar: :any_skip_relocation, ventura:        "bfa7a060a643ec55e90e08d102b67b69ec41629e21376fedd5bdd2d6571008b0"
    sha256 cellar: :any_skip_relocation, monterey:       "3fb10f1788d670ab13a8313ac1101c59b96bfd2e4ae305b393793886bd9a1236"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38adab6028987b9c34bf924a4eed738d56f25d91f51d4c85a7cfd322fc23145c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{Utils.git_head}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags: ldflags), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", "completion", base_name: "kosli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end