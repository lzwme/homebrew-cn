class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https:phrase.com"
  url "https:github.comphrasephrase-cliarchiverefstags2.27.1.tar.gz"
  sha256 "e0c85df72165ae5c0e726d9ff0bf8725da5cae37f40e70fa7155b898664e811b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "95ac7237ca0369056270d077528273c6382fbaf4dc35c1fbd29110c8fefa8c15"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "75aafc89c721596e73ad243bee7188df8a56590ef00618f7158c12c6b0ab6677"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbc80dcab186834a291678ac9588316600fd6cca9f41fbb57c52496c693aa4fe"
    sha256 cellar: :any_skip_relocation, sonoma:         "45e575a8b0a8b1c1813df8d00a75e2e11698ccef3988fd5a80d3dd7002d74c14"
    sha256 cellar: :any_skip_relocation, ventura:        "d35f27d2f754341bc2736b2f98df77c25256b47aff74d9cda035a582e7bf2ab3"
    sha256 cellar: :any_skip_relocation, monterey:       "b29e0bca8a3b28d15ba2c46716ab350e1cb23286730a8d28e83865c7692e169d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d81c0cf8acbf3d6bd6e6a90872e794e7e1e05d255e8f0d62497f5427c519201"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comphrasephrase-clicmd.PHRASE_CLIENT_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    bin.install_symlink "phrase-cli" => "phrase"

    generate_completions_from_executable(bin"phrase", "completion", base_name: "phrase", shells: [:bash])
  end

  test do
    assert_match "ERROR: no targets for download specified", shell_output("#{bin}phrase pull 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}phrase version")
  end
end