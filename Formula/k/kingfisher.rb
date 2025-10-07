class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.55.0.tar.gz"
  sha256 "878a3ab9c0da49020754a0cc929fafe7f326d822506d83c1314994a4781ce431"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "879c8538649959018fcc2c5aa282674301c9f7fef3184db28b86cd9462c6b900"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f6f90d086943ee80a597756cb52ceeffa2713dfc9e63d27bd1fcb3d529a7bcb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99d817160364e531efe7ffc39051e04a45dd81812d4d3d3a04def8f0f2ac5aeb"
    sha256 cellar: :any_skip_relocation, sonoma:        "e93e7ed782e4fe360f850d63421cabad5f14767e045272c24c0a572c01ed1fdf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f3a524b950718a119b97ca6d89a744cd8a7cad26492bdad49a483362dab42ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a523778323d1cb3105abee5ef2b0f80f82511ff8abf47bf59efd1d5939351e4"
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