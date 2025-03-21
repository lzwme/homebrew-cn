class Glyr < Formula
  desc "Music related metadata search engine with command-line interface and C API"
  homepage "https:github.comsahibglyr"
  url "https:github.comsahibglyrarchiverefstags1.0.10.tar.gz"
  sha256 "77e8da60221c8d27612e4a36482069f26f8ed74a1b2768ebc373c8144ca806e8"
  license "LGPL-3.0-or-later"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9ff02541efeba578a7e20d6d3ba1cd80c71d4f80e37306a35cb9b13e1e9ef4e8"
    sha256 cellar: :any,                 arm64_sonoma:  "783ce52f8a68f8d5900429fd33baf4d728523e19fe63fec93c1de3242ab157f3"
    sha256 cellar: :any,                 arm64_ventura: "d2cf724c8cfdb04e0c94643c4fc456ca85a75148429198eb11b3746c1d23047b"
    sha256 cellar: :any,                 sonoma:        "894c3d629641e0ed82a2f10ac0559658173e91d212605ffc32cfd824ef0c13e0"
    sha256 cellar: :any,                 ventura:       "244b65728e18b1514ca9b3fb77c09d835ce07d98656567b0b62f90365716ea92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92a13d57476ddb835effaba42d9c57f0070e4378b8b258711e9748cbfe603e4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "299191466994be32c6b0fd7ffe958623ddbffb940428b95c25eba2fa6b5bff21"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "gettext"
  depends_on "glib"

  uses_from_macos "curl"
  uses_from_macos "sqlite"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    search = "--artist Beatles --title 'Eight Days A Week'"
    cmd = "#{bin}glyrc lyrics --no-download #{search} -w stdout"
    assert_match "Love you all the time", pipe_output(cmd, nil, 0)
  end
end