class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https:goreleaser.com"
  url "https:github.comgoreleasergoreleaser.git",
      tag:      "v1.26.0",
      revision: "0481e63fb3d9d6d1e1d8cbee16789d644b652ab1"
  license "MIT"
  head "https:github.comgoreleasergoreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "06ddd7a01b9319769a9c70415d4548fd0e0c39e97416c9fa7a5acd5acfcf1689"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dbfe99a634ffc319e9755e7bb8de33ad15d199369c34732ffc383b425901f806"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ce9b1a713e9698bdae12643408bc8d96beba0d420ead5a0dc5651cae4a99c78"
    sha256 cellar: :any_skip_relocation, sonoma:         "66309b91ba31881b5b523d65c11f781a48814b07e9cfaedadd828f6e75400752"
    sha256 cellar: :any_skip_relocation, ventura:        "01842b167c04bc084bdc08497cded87c1292b9efabc4b38e2519823eece62214"
    sha256 cellar: :any_skip_relocation, monterey:       "14ccf625b6d60753ccad5ee1fcff7c810df8a525230f292378ef4f7f6ef16415"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c3a779838b04f7bcaca1837f244d3af64ed9d1c3125a91b8ef9a6c3663f046d"
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