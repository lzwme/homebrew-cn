class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.50.0.tar.gz"
  sha256 "89c8325bacd66735c2c20c69b7ec3b09f01b70151697354533ed88433f9f733b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "844fa5c1e6bd2eb8bf11cf7bd22e98abd67608ff05218d5455be8a0ceeb5401e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dddaf7d4843c1ea3e1a41c0da81fefe78a93f1deb4b7cfaa757e965461ae8351"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f63f34252c823cd97043f2dbbe8f13abeaf6ec1d11f6fc67a87e962a3fee3af4"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9a1d35056a0146e403bcfef4f3061570e068091e5dde3859c471aa5c26685d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23bbe6e7d250a8881d03a4d3d1a3bbd3f7591f7968658b49f5eef02ab1df5bd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "360faaf29ad47649db7069dd72a4c30aa57d96398c42ad821dc69ff1fe52359f"
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