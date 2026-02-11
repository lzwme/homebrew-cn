class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.80.0.tar.gz"
  sha256 "2efb5c517fe84f715f667965b951356bd830649a205c8b2cf403c52cb95706f4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ec69793d146c4c7af5e1e8bada075762fab07b3d8df7955cb82a4959aa2a0f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e19f38320356cd4db0994167e2aeab95a468771f200f031548f595d85a95e5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05b1fc6b355921242b29ddc6be158958263d5f75daf52cecfc01ec01cc541b98"
    sha256 cellar: :any_skip_relocation, sonoma:        "c305aead11d4f8edfe4a19acf223086d20f38f9923882db933022515ee169c06"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "933b3ece36f6248c5cdb0bd69fccb6cc34ceec93d8ee8fc605a6d0ac60df5328"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9385f1cf2790e140f911956bf1695422223e2513b9f153b7f28738cc2fb1aab"
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