class Chainsaw < Formula
  desc "Rapidly Search and Hunt through Windows Forensic Artefacts"
  homepage "https://github.com/WithSecureLabs/chainsaw"
  url "https://ghfast.top/https://github.com/WithSecureLabs/chainsaw/archive/refs/tags/v2.16.3.tar.gz"
  sha256 "03b88020baf29f30bf763f132012a21d54d8758c2fe6b67e0521265ec5710764"
  license "GPL-3.0-only"
  head "https://github.com/WithSecureLabs/chainsaw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c526ddb6d1ec07f260275385ced0c998521d372b4a5a914d65c02d7fb6547346"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "754eafab7f23d27e2b218b8728d21e4855a49e77fbcf6b3db3d7231bfde9c377"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5fa830e74180c6d4f0a8870556364a1c784d0d833c15dc57cc5b72c5f317f986"
    sha256 cellar: :any_skip_relocation, sonoma:        "7adee20d497acb24c6b732efd1301eb68ef92e45634e04bf908801327d09ab4e"
    sha256 cellar: :any,                 arm64_linux:   "9d49eb88e5604875b2ef3f0ddbd68a6fe5d1a5a1fc9f72e96577a4498861166d"
    sha256 cellar: :any,                 x86_64_linux:  "14a2814d49cd537bdfc32ac5121ed9e1fc832bf817a141f9e2457e40fb54005c"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    mkdir "chainsaw" do
      output = shell_output("#{bin}/chainsaw lint --kind chainsaw . 2>&1")
      assert_match "Validated 0 detection rules out of 0", output

      output = shell_output("#{bin}/chainsaw dump --json . 2>&1", 1)
      assert_match "Dumping the contents of forensic artefact", output
    end

    assert_match version.to_s, shell_output("#{bin}/chainsaw --version")
  end
end