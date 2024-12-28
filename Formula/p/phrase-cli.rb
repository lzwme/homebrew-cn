class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https:phrase.com"
  url "https:github.comphrasephrase-cliarchiverefstags2.35.4.tar.gz"
  sha256 "54bd23f2da743b11b8e874a110db6c204dea0f96bd8905a1205a22944fd76af1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37da646bb123d62ae2766c736b5c7e6a9a49e4e1de10831875405a02045ae736"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37da646bb123d62ae2766c736b5c7e6a9a49e4e1de10831875405a02045ae736"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "37da646bb123d62ae2766c736b5c7e6a9a49e4e1de10831875405a02045ae736"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb225f3de6980570633065392d01e0e4e9ed459a2b9e7f8e945f55cac4499e07"
    sha256 cellar: :any_skip_relocation, ventura:       "fb225f3de6980570633065392d01e0e4e9ed459a2b9e7f8e945f55cac4499e07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e463a17f817d3d6bf14b541c30653bd4191b41195a516fee0db3ad56df3d054"
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