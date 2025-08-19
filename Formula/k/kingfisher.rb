class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.42.0.tar.gz"
  sha256 "99fadfa2f03e845613b2141c53dfeb82e0251183bf9063217540eb64bfe403cc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22bc9bc1a5819a5ff24cdd184eed5e86631c87ed581977753570e30858ea95e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "915e82dd65035942f7f50deed2abef48f3b50722ac3487caf53504c3cc7487ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e32b48524e4f858985bc25b92fa06ee607016c8fb71d3cb07e8225d60e0860ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "6cae58f155a083ded24d53a0166f7c39ffee6dd679499a5da7e9e5f8e420aeab"
    sha256 cellar: :any_skip_relocation, ventura:       "3bac0d015c49a9cf41e3ba7616ba136adc605b367ed6556c2156541359b3fc21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a896d76d29710f6a7f142b346b0d203c6689e792fa2e050d986499bfb4e1fc74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9dfde0bb2dc9d2d21e388509cc2aeafa181c73989a397780b3be50df3524896a"
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