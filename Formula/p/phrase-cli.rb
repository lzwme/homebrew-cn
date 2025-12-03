class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://ghfast.top/https://github.com/phrase/phrase-cli/archive/refs/tags/2.51.0.tar.gz"
  sha256 "67cf34bcda485e95069c450a2130bee04c627d12bcad48ac02cbea4a55769434"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "816d007888a476dbb23ef22c74068ec6e135fba9f197fac42431c46de7d58181"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "816d007888a476dbb23ef22c74068ec6e135fba9f197fac42431c46de7d58181"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "816d007888a476dbb23ef22c74068ec6e135fba9f197fac42431c46de7d58181"
    sha256 cellar: :any_skip_relocation, sonoma:        "fae7d74fa75f731bccfcaf3a559295b2b344779b956cf5714af423c62236ee91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9fa58048f4ecaa40835f68de38a21508c3ee31301033caee768fca67acb9bcaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2d7baf0fe3c3876590aedfe801682c3bde8fa50a43e6a3f909534439d972e73"
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