class Ipcalc < Formula
  desc "Calculate various network masks, etc. from a given IP address"
  homepage "https:jodies.deipcalc"
  url "https:github.comkjokjoipcalcarchiverefstags0.51.tar.gz"
  sha256 "a4dbfaeb7511b81830793ab9936bae9d7b1b561ad33e29106faaaf97ba1c117e"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "34f1ac1f3130d85231cf0af66acd5d46b21bbdaa9a32153ae71c7d9977c36c57"
  end

  def install
    bin.install "ipcalc"
  end

  test do
    system bin"ipcalc", "--nobinary", "192.168.0.124"
  end
end