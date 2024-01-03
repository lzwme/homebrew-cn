class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https:phrase.com"
  url "https:github.comphrasephrase-cliarchiverefstags2.19.3.tar.gz"
  sha256 "82cd2c1490f1871386b44d789e3f0067ae3541196915ce3c8294bddf28942e3a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8a4e2e789df7b7e3f5f5ceac5f5c69c6c6f5161c724165e1ea4b12fc81c58ee4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9b49608d5065122986d621513edcfb5fe8f5d84333d69879cc970c3c085aade"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f443e2a2771377a8e8614b5921355e1cd26db6d5bf21d68ccf5b7bc11c0ff88f"
    sha256 cellar: :any_skip_relocation, sonoma:         "0b430c3e7070f95839faddebe78f5ddfff3ffd7c8974beec40a5f65b0ff64671"
    sha256 cellar: :any_skip_relocation, ventura:        "e3467566e55135bf0f19de509108d8048721a76c7ba1c70cc81dea1c7e8c1b1a"
    sha256 cellar: :any_skip_relocation, monterey:       "f359f09798a538c25ba5a88321df574cc1ed17ca16b9234757ea8aa02d189f99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c48ff345c035e1c5bd24aef97942969077d78eeec3fd077975f75e83a15053e7"
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