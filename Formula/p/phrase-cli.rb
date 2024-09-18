class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https:phrase.com"
  url "https:github.comphrasephrase-cliarchiverefstags2.32.0.tar.gz"
  sha256 "e067de46c3fc630a53fdc7f74101582df5dd58ed55fd0a8274ef6ff933a71af4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd6c7a3252ec1e1f200f8fb5a53da60964aa07246346ba74be079b2f502fe86b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd6c7a3252ec1e1f200f8fb5a53da60964aa07246346ba74be079b2f502fe86b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dd6c7a3252ec1e1f200f8fb5a53da60964aa07246346ba74be079b2f502fe86b"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd8492b78eb43b5d9c1e69e42272d29a12e62b07302bd56134925503968f0e89"
    sha256 cellar: :any_skip_relocation, ventura:       "bd8492b78eb43b5d9c1e69e42272d29a12e62b07302bd56134925503968f0e89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd5994003f5288f37ef339f2bc1ec9749141d6adf753e56fd17a16336d5b0205"
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