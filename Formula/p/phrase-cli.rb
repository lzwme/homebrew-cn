class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https:phrase.com"
  url "https:github.comphrasephrase-cliarchiverefstags2.31.1.tar.gz"
  sha256 "abe756d192e43ff3bc9b3896093c469185774827c779d60c033073e4f95a89e8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ca7693f351fd06907d1c76a7ad74ba16da5f7375bd606a68691ff508cdf75f0f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca80a8bf21d03ddf777b5390a93cda789ce3360875b052bcf311c47a431c2ede"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "994ee634ab6469e5b3c687f7006929ce446ff153334b4f2f4fbac0571b50cca9"
    sha256 cellar: :any_skip_relocation, sonoma:         "852ca13d5ca49ef7b4b66738570a5d0f084ef30507fcd6ebb4d4a2e7553ddb9f"
    sha256 cellar: :any_skip_relocation, ventura:        "6925968f67df8d1548b3702b99227476ed4908be8086b25dcc114879161ee224"
    sha256 cellar: :any_skip_relocation, monterey:       "af3fa8b4d3dbe6145b59153797740d39b12832e168a2d379510557e1d79dd9b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a57018767a27a37b555f1aed762bf97539a07c6107a0a486b9e196cd4134033"
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