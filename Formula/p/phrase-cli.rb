class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https:phrase.com"
  url "https:github.comphrasephrase-cliarchiverefstags2.38.0.tar.gz"
  sha256 "408f58c18c9e44ebcacdc660f8d1077ae531b22b1a194bbb05fca88d18cdf12e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "237a225e873091637ecce08e1979160743aea38971345d6f37402499b8978181"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "237a225e873091637ecce08e1979160743aea38971345d6f37402499b8978181"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "237a225e873091637ecce08e1979160743aea38971345d6f37402499b8978181"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ac0de5cc1459506f2062aa8506e4bba253ae54d3b545cdf0ba43ad25ce7cf59"
    sha256 cellar: :any_skip_relocation, ventura:       "2ac0de5cc1459506f2062aa8506e4bba253ae54d3b545cdf0ba43ad25ce7cf59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46b8480f48a9dbb931a90fc6b627d4b375021129589e95ca36ad45a5ebb1bb62"
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