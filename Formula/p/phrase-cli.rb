class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https:phrase.com"
  url "https:github.comphrasephrase-cliarchiverefstags2.36.0.tar.gz"
  sha256 "2ceec4dafe4421c67fe4c126a4b37cd17eb13cb871d5f50bb521cbf796cab9af"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5d6dd2cf2275e6e61ba88a691706d997727583c3f4f260269e7c0aba0c786a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5d6dd2cf2275e6e61ba88a691706d997727583c3f4f260269e7c0aba0c786a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f5d6dd2cf2275e6e61ba88a691706d997727583c3f4f260269e7c0aba0c786a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "c31fe57b138fbf303c46d79defeaaea7eb92187a0aaff06804b87c7b79d2a6c1"
    sha256 cellar: :any_skip_relocation, ventura:       "c31fe57b138fbf303c46d79defeaaea7eb92187a0aaff06804b87c7b79d2a6c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a59e33bea973d8ccaa09d084a704ef6d9e3d35932f2ab7f3ae3bdb3c7facdebe"
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