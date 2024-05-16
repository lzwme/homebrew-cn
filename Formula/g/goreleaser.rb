class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https:goreleaser.com"
  url "https:github.comgoreleasergoreleaser.git",
      tag:      "v1.26.1",
      revision: "19b94f676f35f8a2d1928db6960cb7b35913d783"
  license "MIT"
  head "https:github.comgoreleasergoreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b32709ed8c41b8b33fd5703a62ead2c294634b267356c3acf1ca22d4a0df2a9b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "091e43751bb4bae9d480d6cac660ec02d67c1d2fbafd707afa14533a30024e2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f9f28ea8d9e048406d6ab5fa2bacf5523f8cb94afa8e078334d4ff8cc2518f8"
    sha256 cellar: :any_skip_relocation, sonoma:         "878f58650610b28e4d571ded52a298f15387e8e15f52e8540d79d8f71f25fc1d"
    sha256 cellar: :any_skip_relocation, ventura:        "22d90a2ff39e90b1ea114beb1b3c15d46e40ca76cc48cf97eba17c775cc8d257"
    sha256 cellar: :any_skip_relocation, monterey:       "757a6ca47a66a9750cb63a0c8714981cb900e959a82f5763664a6012cda6c356"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb5121c9d0046ffe40c557c2e63d9ce2b62a2d2947072a45cb9dfb57aa8701fb"
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