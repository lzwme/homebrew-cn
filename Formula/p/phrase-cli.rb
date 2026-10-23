class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://ghfast.top/https://github.com/phrase/phrase-cli/archive/refs/tags/2.70.0.tar.gz"
  sha256 "268586498e922736199097a41cfa8700a6f05e252eb7e33c7e08e3000311f8a6"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b5c3186af0134fd21914862bbbe045624b570b3a47b19612b6fc9e96577c9304"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b5c3186af0134fd21914862bbbe045624b570b3a47b19612b6fc9e96577c9304"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b5c3186af0134fd21914862bbbe045624b570b3a47b19612b6fc9e96577c9304"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1709f516fcc8c1176c915b2aa164ec48c5dbcedee9c40dabdf31a5017ec08e3e"
    sha256 cellar: :any,                 x86_64_linux:      "68e762ece360cc2f8c1f8b66dd81f5e7e30188108f3aeb86f2085d9be2ae2b7e"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/phrase/phrase-cli/cmd.PHRASE_CLIENT_VERSION=#{version}]
    system "go", "build", *std_go_args(ldflags:)
    bin.install_symlink "phrase-cli" => "phrase"

    generate_completions_from_executable(bin/"phrase", "completion", shells: [:bash])
  end

  test do
    assert_match "ERROR: no targets for download specified", shell_output("#{bin}/phrase pull 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/phrase version")
  end
end