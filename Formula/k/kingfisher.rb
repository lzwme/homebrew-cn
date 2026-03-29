class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.91.0.tar.gz"
  sha256 "7f5e23d17163d1f4f716b81fc86f1813af6ead139cf48c037d68d85fba71c566"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c737f47363042a654720f0f8b30f529c77c830de84b0ce894992fa8e5bc72e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc1b4dc72e654b0932862fe89f839c00eadd096438d53b3617468c195c77dfdb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cee24bbb28d18d34c30ccbdf98ef3044dcdad232d2ef7f6cff7b1304522fa81f"
    sha256 cellar: :any_skip_relocation, sonoma:        "f119c9502faef494c86f6e8e5b316ada95a6bdd4ceac15c18e13cb0588dc2949"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f62989a113711fa70f9c03f912b222b1f84fb91a09f1224dff7061236dbcfbb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bb941ebeffa7adb72599f2aa70f6975e5fd8253d3915889261ac6f68225802c"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  def install
    system "cargo", "install", *std_cargo_args(features: "system-alloc")
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end