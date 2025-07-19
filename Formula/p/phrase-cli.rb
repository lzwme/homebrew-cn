class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://ghfast.top/https://github.com/phrase/phrase-cli/archive/refs/tags/2.43.0.tar.gz"
  sha256 "2b1dace6724e4d321da5d88f3e8c66250829f66f64537934b68fa4fcbd7e664f"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40a85216d071cc0129c32a618e922ebee381f7e890405746564c0c6ad3854fcd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40a85216d071cc0129c32a618e922ebee381f7e890405746564c0c6ad3854fcd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "40a85216d071cc0129c32a618e922ebee381f7e890405746564c0c6ad3854fcd"
    sha256 cellar: :any_skip_relocation, sonoma:        "2748539bd77253aac2a8dcedc16a1db076a6b33e8ea1fa2fcb733d25aa018eb5"
    sha256 cellar: :any_skip_relocation, ventura:       "2748539bd77253aac2a8dcedc16a1db076a6b33e8ea1fa2fcb733d25aa018eb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a3f2f4e32103d78cf43870808a801610fc724390591359cd3322884cb969b53"
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