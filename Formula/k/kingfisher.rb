class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.64.0.tar.gz"
  sha256 "dd5561c70c27dbf94d8ce549edef42a2a9edae53bb9dc9b9c4fd2ed3e0b0ec96"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77c010c5b155ed5603b463b2177ab16d23def1ed0b58ec9f2faf67a2b3ad0284"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47853b23e4010a44bc42c2c81459ec9388f8cf6656e23c33ad82406c84a25d28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec98c4b235f3fae526cd535382d7b6e8f2e4759726d9a98ef8d454c427379032"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd553e8ac1ae00296a00ec245cba51b11b5092d9fa5d39c7ef14c07d9ab13845"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0230334f94e56ed978457fca1091d7e49841c2f33e2b5227b9252ede92f76ed9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "569bcb213c12f061f6c41b9a5bfcd563f85779bb2c04f8d9c1011669632cefbc"
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