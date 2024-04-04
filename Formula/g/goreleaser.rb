class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https:goreleaser.com"
  url "https:github.comgoreleasergoreleaser.git",
      tag:      "v1.25.0",
      revision: "6353982e33d11c2e2812e891fc3431ef87b436f2"
  license "MIT"
  head "https:github.comgoreleasergoreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b61523004a490d708acf633276c3d3819a745534f0febd70bf2eeda5842d27bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c6e05302ef545c529e6af0ac83647de2fa0b9bd683842afe300eee503315e19"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c3fb7b2ddd6cdadff492302b23abf0423b7d20759ea0cca7e311cbc82b78d5e"
    sha256 cellar: :any_skip_relocation, sonoma:         "1e3e8f274a92177a09eb3f58afea270b9bb38309a27d830177aac44427f10a2e"
    sha256 cellar: :any_skip_relocation, ventura:        "b64393c716235a85b6cdda2825719779ae115e4ce39dc47628494ce9b1e1c919"
    sha256 cellar: :any_skip_relocation, monterey:       "37e35e818c72c4074e198bd8e996d520a68c1c9acf6e365150d837a3adea2f94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bdd6f4656f64c5d83cc87eca9f2701afbd84935a897adf3fe0febfaee429cae1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.builtBy=homebrew
    ]

    system "go", "build", *std_go_args(ldflags:)

    # Install shell completions
    generate_completions_from_executable(bin"goreleaser", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath".goreleaser.yml", :exist?
  end
end