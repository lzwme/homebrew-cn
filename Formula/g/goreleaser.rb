class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v2.11.1",
      revision: "21eefb16cfc5346f9cbe8fb0513ee1840353c324"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e3ff91d931da9808742dfc3c649521a5478656235c222d8d0e20871531ed58d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e3ff91d931da9808742dfc3c649521a5478656235c222d8d0e20871531ed58d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8e3ff91d931da9808742dfc3c649521a5478656235c222d8d0e20871531ed58d"
    sha256 cellar: :any_skip_relocation, sonoma:        "018b68714ef2a6978c62e9016cd894d34b18a69a5a15a48c6df60acbe8085696"
    sha256 cellar: :any_skip_relocation, ventura:       "64058faacb33100d6f52139310612862e9341214b4f23e3737a340b249c2fc5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c19c84cfa6c9e78bd1e87cd6ff3733382a0d667051fbdb8a130ef94ec1cab85"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{Utils.git_head} -X main.builtBy=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    # Install shell completions
    generate_completions_from_executable(bin/"goreleaser", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "thanks for using GoReleaser!", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_path_exists testpath/".goreleaser.yml"
  end
end