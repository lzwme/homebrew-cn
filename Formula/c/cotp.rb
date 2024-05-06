class Cotp < Formula
  desc "TOTPHOTP authenticator app with import functionality"
  homepage "https:github.comreplydevcotp"
  url "https:github.comreplydevcotparchiverefstagsv1.6.1.tar.gz"
  sha256 "d748072a7b0f30606b046fab9a38a07d7846d40203fd7e78ab43fa410caf6338"
  license "GPL-3.0-only"
  head "https:github.comreplydevcotp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "841aaacd5576f616b588881acaf98b465415c90b50e380c705610137e87e0256"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae61c244b70a462c089cfeedf417febee26711b6873b123ac75f8dc08b14cc9e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e674ff567bfc09ba01c140f7f5b23019c2aaaa2ffa9e09bfe347c2f2dcd31e74"
    sha256 cellar: :any_skip_relocation, sonoma:         "2081508a193d726f282f0ce1aa920b8a8153800806222156d20069a3bafee652"
    sha256 cellar: :any_skip_relocation, ventura:        "89b115243cff3ae44ef9270655b5a9243ac7e9424a4e12b596f067520fbdc945"
    sha256 cellar: :any_skip_relocation, monterey:       "c1047cb33f1c279285ab573bd4cf050d66b05680ee27addba1cf696f3a90fc89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c54a85ea48176dc55b87cdb67498ba42e3e5f7af30309a15bab04cf5e005790b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Proper test needs password input, so use error message for executable check
    assert_match <<~EOS, shell_output("#{bin}cotp edit 2>&1", 2)
      error: the following required arguments were not provided:
        --index <INDEX>
    EOS

    assert_match version.to_s, shell_output("#{bin}cotp --version")
  end
end