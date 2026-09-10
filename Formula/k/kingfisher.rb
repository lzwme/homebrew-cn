class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://mongodb.github.io/kingfisher/"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "7262b2740f6b2da83bbbd84285a70f63302cae431560ae3e87764103f86dc6e8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07dc2acf1cabd799a146bf16ae8f05cf6a7bea0c87ea2a623bdce725e3acfeea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37136a3a69d524e024814d6847765a19fc0f1723b227eee552099cefef03190e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e5307e45f3cfa351c81bfdcde4a31cb7d5e7a38ec4c878b40d65bfdc82dd0e5"
    sha256 cellar: :any,                 arm64_linux:   "0653ea964278cb508fd99eb4f1d40dea50e51ad099130d7f3d8f5d7c5d0516e5"
    sha256 cellar: :any,                 x86_64_linux:  "75df681456c127d1c3f02d498fd4976376f074781ac3e93d78218900eb2e1863"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "openssl@3" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  def install
    args = std_cargo_args
    args << "--features=system-alloc" if OS.mac?
    system "cargo", "install", *args
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end