class Vultr < Formula
  desc "Command-line tool for Vultr services"
  homepage "https:github.comvultrvultr-cli"
  url "https:github.comvultrvultr-cliarchiverefstagsv2.22.0.tar.gz"
  sha256 "e6562f28bf7475fa92db3b90a9a350537c588c71f0e76348abf2d87bd9e70151"
  license "Apache-2.0"
  head "https:github.comvultrvultr-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9ec87ca3b1d32787f876266727f48584d54344dcafbaf5af374d576811cc4a15"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "53fefd02268d22404902084d4d1d6248e7db422e504ce7368a036ba7f4d23f3c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ae12c68abbd0f53092fc7b7c7974ebb0f176f554000ddd515338b65603d966c"
    sha256 cellar: :any_skip_relocation, sonoma:         "fbeb153fd4c9930773c4a482ad909f2ab6fc21e56dd772bedac62e7759db485c"
    sha256 cellar: :any_skip_relocation, ventura:        "81f26c277475096226b844a31de812d2b6cd59f691d6dde605c943eb6f4ba18e"
    sha256 cellar: :any_skip_relocation, monterey:       "8eb612deaf8241bac707664718d58257a5114b7ff165cf44097a8c7b04fa045c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0629265dd607ac4aec402173b65189e65bebbc8640ffe6e182d60bb2d1e3e48"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin"vultr", "version"
  end
end