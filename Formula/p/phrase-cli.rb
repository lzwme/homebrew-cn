class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https:phrase.com"
  url "https:github.comphrasephrase-cliarchiverefstags2.42.0.tar.gz"
  sha256 "42dd084ef2b622e33c524dabfcf6d7e1f74f52d3a1930e942cc91e25720e7779"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd66acf469f2e9fafaf949c734597c6f016fb222b016e4ce139c60f2c7403280"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd66acf469f2e9fafaf949c734597c6f016fb222b016e4ce139c60f2c7403280"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cd66acf469f2e9fafaf949c734597c6f016fb222b016e4ce139c60f2c7403280"
    sha256 cellar: :any_skip_relocation, sonoma:        "278a769c0e243735a5fef5d290ce8a6c5c1df09523709049bae23696d8a20708"
    sha256 cellar: :any_skip_relocation, ventura:       "278a769c0e243735a5fef5d290ce8a6c5c1df09523709049bae23696d8a20708"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04bbd1a3c0ddccec522a44a5fc8e5127ba2a67ada44a7759e069b795180f1e47"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comphrasephrase-clicmd.PHRASE_CLIENT_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    bin.install_symlink "phrase-cli" => "phrase"

    generate_completions_from_executable(bin"phrase", "completion", shells: [:bash])
  end

  test do
    assert_match "ERROR: no targets for download specified", shell_output("#{bin}phrase pull 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}phrase version")
  end
end