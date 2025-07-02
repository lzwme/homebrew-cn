class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https:github.commongodbkingfisher"
  url "https:github.commongodbkingfisherarchiverefstagsv1.18.1.tar.gz"
  sha256 "4e935319a9e6760f683c0310a56d8720700bb7e66e5ccd60291efa93c7bf78ea"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "057c527f4fd697a3e5f1e3b053d0bd5abb219c98ae0fb1816b3f6ed8e8b89776"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a42075334de10a8a3eb902dadcd82f96f60088462f7155fef80d4e2735beb831"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ccc6418ef64d2adf745aaf5b27f3115cd8d99265fa43a1fc13af0fa07b725565"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d21ca43f4364f919713db0da4525c0c6dc2a102d5ad5a9b9b545a2cf4739a15"
    sha256 cellar: :any_skip_relocation, ventura:       "6f8cc42e405f923ba093795b431ea5272d45f1c57c8ce21f7beb91aca21de7c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "989a88e82b34d09330fa9a28674245a6826b2e8057f7f67928d60f070643ff56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "560719e64b3fa18e58c31caf64ec91f8ca148f7383a8785951feced9db14c3ad"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "system-alloc", *std_cargo_args
  end

  test do
    output = shell_output(bin"kingfisher scan --git-url https:github.comhomebrew.github")
    assert_match "|Findings....................: 0", output
  end
end