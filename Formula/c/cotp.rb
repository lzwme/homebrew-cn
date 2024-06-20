class Cotp < Formula
  desc "TOTPHOTP authenticator app with import functionality"
  homepage "https:github.comreplydevcotp"
  url "https:github.comreplydevcotparchiverefstagsv1.7.1.tar.gz"
  sha256 "62c7bd4b5f3435cc04add28041a896ea76605c0c0675e711672b2dc2221cbccf"
  license "GPL-3.0-only"
  head "https:github.comreplydevcotp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "91ebb7aa5f53d1f8ef8601dbd0f96dd60569f274905422ed90450d48211b9e2b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d82fc9ae1c8db9333bcb1a5c81adcc97d4e29108ddd75c37faeab5ac9b324311"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e40c68be447fe4403e470f7f852d0e4e8e9ee6e8880adec3166a89eaf500c3ae"
    sha256 cellar: :any_skip_relocation, sonoma:         "f4e15c74c1a26a5cb8ebbec95a86618a3d180f1ebe0cbae044ce4186f9c89d0d"
    sha256 cellar: :any_skip_relocation, ventura:        "26387825ec4023b6094ea981c49b5200146fecda4323f199b98736cbf89bbfbf"
    sha256 cellar: :any_skip_relocation, monterey:       "6272afdc1ea694aec603d5deae5ac30a7c7a0b2f9e4c7a75dcc05c1611d240ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0721b853e66ae1be61dc8937e993cf917583e11fe1b6fc9a3a929d12114203fd"
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