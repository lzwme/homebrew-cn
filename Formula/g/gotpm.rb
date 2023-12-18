class Gotpm < Formula
  desc "CLI for using TPM 2.0"
  homepage "https:github.comgooglego-tpm-tools"
  url "https:github.comgooglego-tpm-toolsarchiverefstagsv0.4.2.tar.gz"
  sha256 "efaa8fcc40b9552ee5f2a83c66e32980e611e68be5a9dc8ecbdc160f93d06fa8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "10409852abe9c8eb652bd27f940e49d0f1be7f0bea0550ae7e98d7285b4214c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "033fe9d2c32fac0297c409aeac6a746351461ddc009bdc226daf700d37df9cef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0aa423a21df58542cf94d1c08b7e114f71b181eb71e7ff260ad98be5efc4905"
    sha256 cellar: :any_skip_relocation, sonoma:         "5aa35812ec29fe9a7f1a41e14876fc1a48a2cb512906beaffe7218c67024b697"
    sha256 cellar: :any_skip_relocation, ventura:        "9ab920734938a43c01f1d168e9768b1a63fa60f116a8862055fe790464a16d81"
    sha256 cellar: :any_skip_relocation, monterey:       "a44b5e55884ea822754730625a8cb904ab9977b9f8ff3a55b92abcc7af6f20a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3e8b38dbe5a86e4107b3228bf5bad41ab69c43e401f1bebcf385434184abff9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdgotpm"
  end

  test do
    output = shell_output("#{bin}gotpm attest 2>&1", 1)
    assert_match "Error: connecting to TPM: stat devtpm0: no such file or directory", output
  end
end