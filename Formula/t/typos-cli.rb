class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https:github.comcrate-citypos"
  url "https:github.comcrate-cityposarchiverefstagsv1.18.1.tar.gz"
  sha256 "a1207e03c506c1b692ddd082c53c087018b8cd83c7282f86f9ecd8093cc1f461"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "407550a80a60994f3c3949b2a72b9e13a32d4eb2bf00c54d2c4199c11f16a239"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3aa24f302a319f95e9b6eb0d7676e2f744838272d5029e0e83120b4e19e01131"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "beecb7fb03011bc5347c0829a2ef9c90e67139c1b1b17f8ef184eed71af1b9a4"
    sha256 cellar: :any_skip_relocation, sonoma:         "3a6faa27d003d7d085b2a205c00312258cc55c8c538bb8929bc14a40e4e47cbf"
    sha256 cellar: :any_skip_relocation, ventura:        "daf20467d14a5b3eaa767475071031bfb807a23b864328ef8d11840fa491a853"
    sha256 cellar: :any_skip_relocation, monterey:       "4e8ba445c8206984d25c6fccf3e17e5e3ccafe4d13cd94e2530d3d296fbee6fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53cc0767c8f87b7085a002a80f6ea6f248293ace76462137c8759a96bc4dc20e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratestypos-cli")
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}typos -", "teh", 2)
    assert_empty pipe_output("#{bin}typos -", "the")
  end
end