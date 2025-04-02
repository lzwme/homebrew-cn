class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https:oxc.rs"
  url "https:github.comoxc-projectoxcarchiverefstagsoxlint_v0.16.4.tar.gz"
  sha256 "75b9d2e026a3e75d075227fb6e502d60ac5531af49df1c561a69d3d4cdd3beeb"
  license "MIT"
  head "https:github.comoxc-projectoxc.git", branch: "main"

  livecheck do
    url :stable
    regex(^oxlint[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "616f1d10b2f8c4ed9fcdec35577c24f9e7dadcf11254b987cd71aa55528da9d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84ed398554fc4739acb0bc1006c3378099d4fb1ee928a0ce7cd9659d7d0561b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1a298891042df08b2d199361586a57b00539c6a4a9cc7bb7d09d4e9e7780d2eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "eded2bf5e347743da36548092eafb4592fb9e512fdb735bf06cc55f98988eb2c"
    sha256 cellar: :any_skip_relocation, ventura:       "7adeaa9d06a72be6ea2a99c3e09e67fe1e9c380f7021f40fd045a13f6fdec0f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd4b4dfdd7a1f14f322456f8757beaab196fc38fd1b7ec5bca0d01ed461e7edf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c612a6deb6350d421433e07ab55f810e243a10503808da48fe8046d1cf75fea8"
  end

  depends_on "rust" => :build

  def install
    ENV["OXC_VERSION"] = version.to_s
    system "cargo", "install", *std_cargo_args(path: "appsoxlint")
  end

  test do
    (testpath"test.js").write "const x = 1;"
    output = shell_output("#{bin}oxlint test.js 2>&1")
    assert_match "eslint(no-unused-vars): Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}oxlint --version")
  end
end