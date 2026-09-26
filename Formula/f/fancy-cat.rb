class FancyCat < Formula
  desc "PDF reader for terminal emulators using the Kitty image protocol"
  homepage "https://github.com/freref/fancy-cat"
  url "https://ghfast.top/https://github.com/freref/fancy-cat/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "c40cd59bef243b3bafa80a33ac97d07c54ab27490d13702abeccbd713f59e37c"
  license "AGPL-3.0-or-later"
  revision 6

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "db1147d423bb1b25373b7383f3a0007ceabdf4044206389c2e7c149a5217bf0b"
    sha256 cellar: :any, arm64_tahoe:       "a93cd39a812cd2e8dd892180bdd2df1f083816915ff615e156c98ef906595bc3"
    sha256 cellar: :any, arm64_sequoia:     "2ef3f352a364ea0a6af9b0466273af4da46db98564aaa45d35a803102c951628"
    sha256 cellar: :any, arm64_linux:       "45ada280706bf87c395786561f3a977d174d015fd028688940f9d9598d302d47"
    sha256 cellar: :any, x86_64_linux:      "6718f46f7a70b7046da627c6a7bc126c6d2da601be76e8fdb4747cf238c29e93"
  end

  depends_on "zig@0.15" => :build
  depends_on "mujs"
  depends_on "mupdf"

  deny_network_access!

  def fetch
    system "zig", "build", "--fetch"
  end

  def install
    system "zig", "build", *std_zig_args
  end

  test do
    # fancy-cat is a TUI application
    assert_match version.to_s, shell_output("#{bin}/fancy-cat --version")
  end
end