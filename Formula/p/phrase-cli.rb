class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https:phrase.com"
  url "https:github.comphrasephrase-cliarchiverefstags2.28.1.tar.gz"
  sha256 "62a8e1134cd3ea30643949fb52e8b91e59c9286c1ea4f53cb35252f79708764a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "036c36d10805ba50d6faf83c67df59204695c5a04b6b2cb7ffc3f946a45cbedd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7fa2b88ecf82f52e03e144c595826e223246605f81a41a04d37ee88e5cb6c189"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7fe3490d1eae496e82f82b239837424ccfd2a8fb500c014b53ffa6c9ae7ca13b"
    sha256 cellar: :any_skip_relocation, sonoma:         "cb552662c7098c0f090e59fd51765228fe0e996fdb46f47d996631769b4ce9a0"
    sha256 cellar: :any_skip_relocation, ventura:        "60d6623306a3c93ee931fea06ad4e549cac98a3a55fe30535f24ddad06676d46"
    sha256 cellar: :any_skip_relocation, monterey:       "05cdc63aac6f2228c72646edc219dde603651c81f977e240d50480b4c264f437"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "caf0cdf8f0f395dce160d3f83e1552ae28e05d95a73a2ed114415481b331440b"
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