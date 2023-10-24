class Osm2pgrouting < Formula
  desc "Import OSM data into pgRouting database"
  homepage "https://pgrouting.org/docs/tools/osm2pgrouting.html"
  url "https://ghproxy.com/https://github.com/pgRouting/osm2pgrouting/archive/refs/tags/v2.3.8.tar.gz"
  sha256 "e3a58bcacf0c8811e0dcf3cf3791a4a7cc5ea2a901276133eacf227b30fd8355"
  license "GPL-2.0-or-later"
  revision 9
  head "https://github.com/pgRouting/osm2pgrouting.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8beb5585b265e918aab7e5f259cd46c7c5b6f5049a57e56a98c18458d40c13dc"
    sha256 cellar: :any,                 arm64_ventura:  "f6d776f603d5e2e5e68272578d6cf68f06ce5408572456a96088eb4403e6f25d"
    sha256 cellar: :any,                 arm64_monterey: "c078ff4f90935b8257115d867d705097203d80a161236ad4829692aa42f6b76f"
    sha256 cellar: :any,                 sonoma:         "94721e5a22ecd53b3bdd0ebf2fac40d5f32768ba80b7a99330713ec02f49d519"
    sha256 cellar: :any,                 ventura:        "2764caf99063bd903c298d6fcb9a15e405877fb265692dd63834c5659ff02757"
    sha256 cellar: :any,                 monterey:       "1981b891faee2dccc0586bc9b78e30ba16fe6895e98e88b4c45134d8d5f637eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d02ca7cedb9b090b998330671b9a3052bf4aeff6b34040c74c38a843629a32a1"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "expat"
  depends_on "libpq"
  depends_on "libpqxx"
  depends_on "pgrouting"
  depends_on "postgis"

  fails_with gcc: "5"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system bin/"osm2pgrouting", "--help"
  end
end