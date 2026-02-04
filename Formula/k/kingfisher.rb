class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.78.0.tar.gz"
  sha256 "1b73e1490308316d34d4c6e68bfbac5aff1a39052e051cb79299c9cd5200baf6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1469fe938a047d4c8c2dffbd612c3b6c3b729604b5cf002ea912ec362002a468"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4fcaaa8b63a100a9168627de25bbed4b649a622151f1e8fbcb963725654f356"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9fa8153d0d0d89018ce1f1caca35cefd5f9b5e903fb07b1290fcf8301fa28cc5"
    sha256 cellar: :any_skip_relocation, sonoma:        "919ecd6ac2266a6c58f1ea5cfc77226ce99e5a06fcc0728385f0be660e5373e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac4f5825e5ca1f7733854867ea30785fb8e03ee69340c0c282bf63aceeb1b672"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "587c2700e33950b9e17fdb9bb9ea5e4248b8268a6849964d7bb0125e6f0a23a6"
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