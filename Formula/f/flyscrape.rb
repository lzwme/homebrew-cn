class Flyscrape < Formula
  desc "Standalone and scriptable web scraper"
  homepage "https:flyscrape.com"
  url "https:github.comphilipptaflyscrapearchiverefstagsv0.6.0.tar.gz"
  sha256 "f6aee457ec9e1eee9346a4ac45c11cd6742881674fb1cb627202162484a7002d"
  license "MPL-2.0"
  head "https:github.comphilipptaflyscrape.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "163a2f6c266ddadaa5dde5a58908378ac14dc8d7f4be2b7ffe53b16af1beed9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b0f92c10fa009f36d3b78f85f6f24922f3d6b326fbd2b7a65b5ca77b5cc2c437"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f200a91ae7461540c6109f5e33069ba079389e0bf3349b1cf8c4f7f47ab48be"
    sha256 cellar: :any_skip_relocation, sonoma:         "24a9ec3af49aeeaf04dd87c03a175c6a145b604fb1c0ae099a5b9e7b05be6f2e"
    sha256 cellar: :any_skip_relocation, ventura:        "f4c80113f8d88fb5eb2288dd43111bd11c481c5cf2cd03ae42cde7c307908605"
    sha256 cellar: :any_skip_relocation, monterey:       "62933a7c98571cba66c79eef64cb58107fd176d23c2fff476a173e27c8662396"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e42015204db5cf98e5cc095b385912d406eaac2ae4e48bb3a74255d8261714eb"
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