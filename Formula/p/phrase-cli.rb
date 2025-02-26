class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https:phrase.com"
  url "https:github.comphrasephrase-cliarchiverefstags2.37.0.tar.gz"
  sha256 "f4a48c37eb0ad82efb3fdcaa421865fe7e4f2f74f91adaaf854008399b46695f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb429e9bb54b1f3b26b37b798664229005abd3a3794c65fead6009d8e98e52f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb429e9bb54b1f3b26b37b798664229005abd3a3794c65fead6009d8e98e52f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fb429e9bb54b1f3b26b37b798664229005abd3a3794c65fead6009d8e98e52f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "1960bd65592a730b98ff69b889229ea89eb16fd653631242e1e2f076d92c7f63"
    sha256 cellar: :any_skip_relocation, ventura:       "1960bd65592a730b98ff69b889229ea89eb16fd653631242e1e2f076d92c7f63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5297c6e200b4af972c15f910b648e1de086c9e0c3afdb01c85cbe21675c67dce"
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