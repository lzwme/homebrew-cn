class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.84.0.tar.gz"
  sha256 "81e8f385533ce6feb60d276986a121eb5a847a7ad06b1dfb3bd2dee932c82b6f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eefc80053ba32ea265b7a58b9f3fde155f41ec0f933ef4903bba01bc4b196b4f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "946971acc3ea4b68f3ad2e364ede23069ed918a7c71d1c9143533ea1034f2179"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20003d48949c7e7562acaab861720ab764f7630f838e344d16766c142c1ba22e"
    sha256 cellar: :any_skip_relocation, sonoma:        "011d5adc365d5d182eecaa1ca30100b71fa176ca42dbb8948012411922cafb59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9333af0f02b7cfd6e6506aad8bdd28d5fe75fc0c2079b9f26502d782b1dfc49c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20b63e17c64ee8504e4c480d3ffdc6e6860a14fc343e34768db26f901de5a927"
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