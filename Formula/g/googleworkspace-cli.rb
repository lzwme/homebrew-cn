class GoogleworkspaceCli < Formula
  desc "CLI for Drive, Gmail, Calendar, Sheets, Docs, Chat, Admin, and more"
  homepage "https://developers.google.com/workspace"
  # We cannot install from the npm registry because it installs precompiled binaries
  url "https://ghfast.top/https://github.com/googleworkspace/cli/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "552098bd723072feca4d6a53f6a5181d513d51624b1324ee2eb034c4bfa5637e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0902c58fe2bb1220d30486f919a4da6450461259a5c852075e6e0474f7455c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87075526a592df13bf106741e894961f2cfb7bc3dd959c927bf1ea633ec037df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df8471aca68a49284f8b2e805fb7f0f43bb9de95afb5521648084d8fe7e22d92"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e4635d407797fa35543761ebd569536c624ce7a3ea4c8993f85ad99c9ac0470"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "332701352c69f9f755d9371f2a28c347b157917e2c1e9a8d1ce55b3add1afa13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf74615d1ae9c2444ac43ab4b60be92457702af17f539b5b4ccd07a2805d8ec2"
  end

  depends_on "rust" => :build

  conflicts_with "gws", because: "both install a `gws` binary"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gws --version")
    output = shell_output("#{bin}/gws drive files list --params '{\"pageSize\": 10}'", 2)
    assert_match "Access denied. No credentials provided.", output
  end
end