class Aerc < Formula
  desc "Email client that runs in your terminal"
  homepage "https://aerc-mail.org/"
  url "https://git.sr.ht/~rjarry/aerc/archive/0.18.1.tar.gz"
  sha256 "f8a2923b1749b1b0eaa9ce221121536d13974297143b597f812b11ebbef0c1bf"
  license "MIT"
  head "https://git.sr.ht/~rjarry/aerc", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "2446f3c97be1ace91d2e527130306cdc86c4e2c67404797ce3517196817ff15a"
    sha256 arm64_ventura:  "5f0902b97013e04fb9e2a16af36d25b62304ebb1731629c6f02dbe8ea4a0fa8a"
    sha256 arm64_monterey: "2c63881a95aad493692a07785e315741ec1115b313345ef8fbb0f276fa5ea437"
    sha256 sonoma:         "051878509b2d02782df127d38fd4d7592714f3378f1eb8535d28f4d6f2341c1f"
    sha256 ventura:        "e3e9dbc76553f52288510d1b6ae7dccadf4bd509b4cd99aa9a8f2c7198f6c5de"
    sha256 monterey:       "af4d2c899c4ca957333bfd10d2f5ec313f232476e9ef86272f0b25c3cfd3032e"
    sha256 x86_64_linux:   "f5f0039a3c3f1e968b7cb1ef0d23b955e33678e889fa72cc3aab1254266e49c6"
  end

  depends_on "go" => :build
  depends_on "scdoc" => :build

  def install
    system "make", "PREFIX=#{prefix}", "VERSION=#{version}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/aerc", "-v"
  end
end