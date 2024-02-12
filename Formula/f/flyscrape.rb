class Flyscrape < Formula
  desc "Standalone and scriptable web scraper"
  homepage "https:flyscrape.com"
  url "https:github.comphilipptaflyscrapearchiverefstagsv0.7.1.tar.gz"
  sha256 "daae5f22270d0564c43220131ffa30c6111fa969bc179cb36e91ff5638f40143"
  license "MPL-2.0"
  head "https:github.comphilipptaflyscrape.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4467ff858ececabacfd74b100ce5dcbda991850d8eea29963a0aa07a255ee50c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ea1f810c5c5347c0b910c425e3f2591a4864c68dba655560921e393bf9564ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24fdc263eb18393b132472c10be22123176d1133f3ad7fbfaa7a269b5d7f1919"
    sha256 cellar: :any_skip_relocation, sonoma:         "fd347604a6f375cb1958df4ade2ea85ee5906d16c08636e35aa121a0a2392868"
    sha256 cellar: :any_skip_relocation, ventura:        "471e45ec2dd8c168969f56262672a548b54f6034b8a729f64e0c0a3306b47bbc"
    sha256 cellar: :any_skip_relocation, monterey:       "559a34230b83faf9e5d7e9914a1f6bf313ee69cc655d6d6dd9a56c00032199ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8aaa6b259db4770bc78a8aa3d344a115cfbec14d14ea6e60061936b54bce60e3"
  end

  depends_on "go" => :build

  uses_from_macos "sqlite"

  def install
    tags = "osusergo,netgo,sqlite_omit_load_extension"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-tags", tags, ".cmdflyscrape"

    pkgshare.install "examples"
  end

  test do
    test_config = pkgshare"exampleshackernews.js"
    return_status = OS.mac? ? 1 : 0
    output = shell_output("#{bin}flyscrape run #{test_config} 2>&1", return_status)
    expected = if OS.mac?
      "unable to open database file"
    else
      "\"url\": \"https:news.ycombinator.com\""
    end
    assert_match expected, output
  end
end