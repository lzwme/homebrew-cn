class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://ghproxy.com/https://github.com/phrase/phrase-cli/archive/refs/tags/2.18.0.tar.gz"
  sha256 "b9fe1b75bbece240a7e6d6391cb62ade0b5828fcb8a656471554777ff7672627"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7927dbcad947ad4c99379cf7be620affe556ec6a98e5452404c8f766f4c4a15f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f7ed1e133cfbc42cf0f6df73f836fb7cd6c343a11adea5db42d7d324e47b380"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0782d3a84afe67a396fae9ce3304f3778c4d3a49e2c515c9fe1dc8c79fb5d61"
    sha256 cellar: :any_skip_relocation, sonoma:         "77b519b3706001605fa33fbe1d20cb34fd1aaea7e119c39bc7ba3e96423e61d3"
    sha256 cellar: :any_skip_relocation, ventura:        "84b0153acfdda37c77e7975093e63d2ce6123cfded97553d7fd8f60bbc1d7c1a"
    sha256 cellar: :any_skip_relocation, monterey:       "0dc5a38a104e1f18ef8922fe7f81d2a8d8ecb3d00978f7b6889a13fc845c6ac5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a07a56e20a00e5a0900105e489e0194cce743d63ba48ac0094236159e4fff9e6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/phrase/phrase-cli/cmd.PHRASE_CLIENT_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
    bin.install_symlink "phrase-cli" => "phrase"

    generate_completions_from_executable(bin/"phrase", "completion", base_name: "phrase", shells: [:bash])
  end

  test do
    assert_match "ERROR: no targets for download specified", shell_output("#{bin}/phrase pull 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/phrase version")
  end
end