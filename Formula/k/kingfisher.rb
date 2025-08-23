class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.45.0.tar.gz"
  sha256 "095adea0177b161935c7a7af1276a88a3f16bc5c8b15af83e6d95d589e93107a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91bf352ad527ed7e9f28159a3e04ed0ecef9023e2e3ab7fc0ba348b3b2b1cffe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b4556d43cd572181c36b854a6ad8cecdefb1d5099d0d4a68e4778f5e2e7a1a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4b060175f62c8a593f785ee19bcb4efba4f4f43c7d89d702494ef5cd20913c05"
    sha256 cellar: :any_skip_relocation, sonoma:        "d57afa7065d93bb52b23607843edfc2ae1abd465ea2d0bda2d7245ed0a1d9f6a"
    sha256 cellar: :any_skip_relocation, ventura:       "cacaac8995c44af1b454bdbb4ecfca44d7120ed6b1df3432fb3606518a307168"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a58943b16671a7468d1b14d722c84e97afc84b60fd91ea5d895a3933e4a05320"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2449dac69375f01d60436fae6bdac84442e1fb8c87f2034e5156f8a70a63fd04"
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