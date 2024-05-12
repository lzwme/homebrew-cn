class Noir < Formula
  desc "Attack surface detector that identifies endpoints by static analysis"
  homepage "https:github.comnoir-crnoir"
  url "https:github.comnoir-crnoirarchiverefstagsv0.15.1.tar.gz"
  sha256 "06b8d1a2dc80580e7116bc14d607d0a036aae02784ecf77d119b499f3237958a"
  license "MIT"

  bottle do
    sha256 arm64_sonoma:   "b3f446fabd93c7dbc69b26cdfb2d3f597f0ee3a911096cced4688bd0b51e0f61"
    sha256 arm64_ventura:  "776575b08430d474a58464165521683368bf3d6b28c074a94e384b32edcf98ed"
    sha256 arm64_monterey: "f20f67095f0830b2c81e04cb927b5d5c7e3d6a4fce70e05447d7b1c387c44d77"
    sha256 sonoma:         "ec0243816657d5f943728fd18f5642875a294eac5e4e92aaed2fee39b9e469e8"
    sha256 ventura:        "d8e397a6f3415f02d33fd6918b57fa9241a04c106b48b2970e73b704e602dc3a"
    sha256 monterey:       "5f71461291315ee65fa9aca0d6eff389709b9b0907369eed4a96aabee59637d2"
    sha256 x86_64_linux:   "7ca826e41a806260714686fcd22e29986d1636f0c4963d24a79c273a13bac64a"
  end

  depends_on "crystal"

  def install
    system "shards", "install"
    system "shards", "build", "--release", "--no-debug"
    bin.install "binnoir"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}noir --version")

    system "git", "clone", "https:github.comnoir-crnoir.git"
    output = shell_output("#{bin}noir -b noir 2>&1")
    assert_match "Generating Report.", output
  end
end