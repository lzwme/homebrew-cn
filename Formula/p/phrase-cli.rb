class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https:phrase.com"
  url "https:github.comphrasephrase-cliarchiverefstags2.23.0.tar.gz"
  sha256 "be13f4c333c30e8d35ced0e12acce0a7ccf805e0c4c31e39306ecdafdd7697bd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dce46954cacd7bcaac7487227f049a596ed86ca68c8b143ab4150422c3a709c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4631c15d352c359e1768e432ba9e7c61847a5ed9c586f09da5961e8b7d549bde"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a798c43891c59a81c080053f57395dc1b1bc13b9fb48856f288e2090c5c3833"
    sha256 cellar: :any_skip_relocation, sonoma:         "f8d6b6d879fbbe496a7a665d0e76da73e7b5040f8e3c1639912731b096c47382"
    sha256 cellar: :any_skip_relocation, ventura:        "cd5160caa80dbc709df2d0092980266dafd7e32cb629a5506b4a1e9af845845c"
    sha256 cellar: :any_skip_relocation, monterey:       "6857883ad36cfe12e463f033e46ee8523f2d8bd9e479742a437149728d878ba8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "374b868a7f09d4ebb2210b876782367ee70c00dd3caecddf818fcf5c069a4bac"
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