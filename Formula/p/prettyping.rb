class Prettyping < Formula
  desc "Wrapper to colorize and simplify ping's output"
  homepage "https:denilsonsa.github.ioprettyping"
  url "https:github.comdenilsonsaprettypingarchiverefstagsv1.0.1.tar.gz"
  sha256 "48ff5dce1d18761c4ee3c860afd3360266f7079b8e85af9e231eb15c45247323"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "507cf7f326024d3e369d6dd816af6391849d3a6c03dd942c5be7df370856317d"
  end

  # Fixes IPv6 handling on BSDOSX:
  # https:github.comdenilsonsaprettypingissues7
  # https:github.comdenilsonsaprettypingpull11
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patches6ecea23prettypingipv6.patch"
    sha256 "765ae3e3aa7705fd9d2c74161e07942fcebecfe9f95412ed645f39af1cdda4b0"
  end

  def install
    bin.install "prettyping"
  end

  test do
    system bin"prettyping", "-c", "3", "127.0.0.1"
  end
end