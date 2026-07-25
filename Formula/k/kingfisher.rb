class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://mongodb.github.io/kingfisher/"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.109.0.tar.gz"
  sha256 "d1c6c9bdcae956709a30cf208dd368fb047c53bd6114019782e000b94d57682d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "222957388c2bcc3af72f87125ae68b23ceacad23dedb42535e09f32876991540"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0568e487c7460956316eccaa615185973a40dea7a7906cb569efc826655eb234"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2066b67adcc6c3f5c0d2f75aa4507645bc34c73968dcad01012e2f40bc6a802d"
    sha256 cellar: :any_skip_relocation, sonoma:        "44572da1d911408ec14b689e8859edd0809c486a09851e82ef9d8ede1ca210c5"
    sha256 cellar: :any,                 arm64_linux:   "5a501fccb33ddd186f3eaa63ff96c71c7da1b75eb4af650d27b3a2d6d148c117"
    sha256 cellar: :any,                 x86_64_linux:  "9bb7a795e18621050ee9a9d179493982e064cfcf413933963ba830f80e72acfa"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
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