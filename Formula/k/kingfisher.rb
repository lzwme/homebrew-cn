class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.61.0.tar.gz"
  sha256 "039efb7ec18c30dc4ee7cb1b5dde60a170dc3c17d10c60c3f0dc852a71b78040"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec3468f50502cf961717e9ecc3feb6ed1fac4060ff93d83d25bf910a41240254"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94cbf07207c98fa1e39b79f5e8075af4a0954fd8a69ea8352e17d531924f9753"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1feaad6f8786e078ad8fe40423ad45636202bb1731c343d6a0ed60de24e01c7a"
    sha256 cellar: :any_skip_relocation, sonoma:        "74cef0b3cdcdc25a2a1df74fe67686653946e33b0139f2925ec1cdce90fcc73a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b893880426682c18f5c7eacdbfe24d39293936c9df75cda8744c383401487e2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70d39a5d2f50ec0b52a74b38245dd2c17560c1247f64b10c1f1a170617d088fe"
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