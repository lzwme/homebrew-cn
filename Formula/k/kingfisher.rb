class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.59.0.tar.gz"
  sha256 "0c7eee48c14e5aaae478b6f739230aab87fddf7a138d0c10b7e1e9eaed892129"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "881632098e9ba6d68b79e481e1653f41be6084f4a153ec20638ef454c820c2a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b03a7d08f7ea77efd274730fa9004d33ee4ed02796b17e83ff0e44f784a2294"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e3f963a2987d60573399db0316ed2b69f0612b54667ec5ca15f730f79bc0038"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e8b7badb77e8b2f504d3242b4931d07f8bb8f93c8a4de6f5b1acf088dc60c87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf086b981103eaf956c96f3201d4561f09a7c34807f78ec29e5e26a034f589d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1bc5b0b0b5dd7c6b54a88772b0eb80c6d0ca0c80876c0668afc994521f2ae35"
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