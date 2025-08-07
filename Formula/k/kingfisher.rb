class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.34.0.tar.gz"
  sha256 "ef2566868d02c91e8bcafd1fff8fb0fcad067c1beba67209595b98f44788f7a8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cfc7a2b5417835844570d5360254abfc23c485944fd33cfb86a81254afa0e46d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f95de0ea5f85a855c1760b8a9869b277e6c8a101ff2863eeaa62833b251fd3bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a2ab3bcddcf065ee4de12d2a96f738e535a468fda2f1ae7f0afac7291112eead"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7a0d8fee28f60de0848ea175e58fc2a360523057b222e8f38bc39d11b9ddf40"
    sha256 cellar: :any_skip_relocation, ventura:       "fa73fdeeddf49389a79d5a4b1d79c7ce131967f21d40f1a660dc602d5b224793"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe71b5d3d003dd03dd0bd9f3f8f69b5196c3c712996bf68ba52c51dc5f5e39f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cef5461e5a3705e6c2b0e8fa6c7147dfdd62877b6735e7f6bc8252903caed80b"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "system-alloc", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end