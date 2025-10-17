class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.58.0.tar.gz"
  sha256 "af6b6b0e53b3a41c9bb70b9ddc61e3ea4e278fb3962782a149616495bac8e472"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70f3d9de91702cc7d1fb367cb657440fc565fd55abcef3bfd4e32a6c7de0fcfd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e48633c47441e22cb473b123e7886664c227ba67d8fb7cf78d466821b2983256"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e2f1a7a62a1ba5b22cb1d7476463e97710a16ac0dedbf68642b5fd462cf10d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "de2bc68670b47873eb6bf8a96995bc7f90b231bc9c225ae3da0dd1dc656cb5f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26f6c478ad336cb168bcfb2edb3cb49b3f47cdcadc27c90cf1cf88dc5135be1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4654746d9f74f870d5f3091a87535cf96d9555f80ae7b8580c2a0ead7090549f"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  def install
    system "cargo", "install", "--features", "system-alloc", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end