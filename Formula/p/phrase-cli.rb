class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://ghfast.top/https://github.com/phrase/phrase-cli/archive/refs/tags/2.57.0.tar.gz"
  sha256 "d4da8754002b4c23bab5f967af45a2f7dc0f6ea1168f82e4593b021f913b8d49"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a5f7f87fa0e4e49d7626082a8c9c4e4109c1d06c485cafffa0318414f6b43d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a5f7f87fa0e4e49d7626082a8c9c4e4109c1d06c485cafffa0318414f6b43d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a5f7f87fa0e4e49d7626082a8c9c4e4109c1d06c485cafffa0318414f6b43d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ac6916b3fd953226ce141d6dd15a85d27ce4924f84b866a1076c7b82e7d51a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94fedf880519cd8c53bd36375e899a0563568b1a74eaf28f0beab73b30db86cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ad5140fc94ac56d829e1e9cab2490aa771a85747b3f525de73d7a072a50284f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/phrase/phrase-cli/cmd.PHRASE_CLIENT_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    bin.install_symlink "phrase-cli" => "phrase"

    generate_completions_from_executable(bin/"phrase", "completion", shells: [:bash])
  end

  test do
    assert_match "ERROR: no targets for download specified", shell_output("#{bin}/phrase pull 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/phrase version")
  end
end