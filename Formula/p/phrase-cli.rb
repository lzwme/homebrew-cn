class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https:phrase.com"
  url "https:github.comphrasephrase-cliarchiverefstags2.21.0.tar.gz"
  sha256 "a4a0cb65b94851251f4681936daee491e48c51822321f654bd4fe3c49d721b59"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "71d7cb53aab251afa460c854844afc92f079dc1d6119bba7e2b32f2aae0747fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea7c4d6e9ffc08f417645169e59a25ecfc6deecb3b49a8d7e61a1b17278a3928"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7562d5e46c59f7f0493d765b54842bc5b11bd4eb6ca2fa66a7e3f280ee9ad8ab"
    sha256 cellar: :any_skip_relocation, sonoma:         "6cce163dd5a9a320339194a51d770a11cb9ed4bacafdc5a79ef030382ee630e0"
    sha256 cellar: :any_skip_relocation, ventura:        "9ec34741822bf9c6b32068c6101653fc158b017091dde3c369dfa316c93c6208"
    sha256 cellar: :any_skip_relocation, monterey:       "d5d59776a8de6acb1f858dca59c9bb389256d63ccf7753ec07ce69d3abd702e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57cb6a7396679a0913ac3be716795836579eadec98adc8064ee4c775fab0ae8a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comphrasephrase-clicmd.PHRASE_CLIENT_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
    bin.install_symlink "phrase-cli" => "phrase"

    generate_completions_from_executable(bin"phrase", "completion", base_name: "phrase", shells: [:bash])
  end

  test do
    assert_match "ERROR: no targets for download specified", shell_output("#{bin}phrase pull 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}phrase version")
  end
end