class Vultr < Formula
  desc "Command-line tool for Vultr services"
  homepage "https:github.comvultrvultr-cli"
  url "https:github.comvultrvultr-cliarchiverefstagsv2.21.0.tar.gz"
  sha256 "c9f94405d089bdf01a7c489b9cc7e51604e08fc7d15ff4b5553ae40015000ec6"
  license "Apache-2.0"
  head "https:github.comvultrvultr-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "98743a6fc972e223ad2392c42c24b0b898d964653cdf64727cdfd8ef34157bcf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "38ce3fc6c458137fba73771b1470fcbc917f16f53be50c220299ecc9e0967f8c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "636a9ea77ff883a4dc71a9b3333e1818d376bc194eef3a6ab0068b339ef6295e"
    sha256 cellar: :any_skip_relocation, sonoma:         "17d602f8017c4ea0510843b952a6584e9b54d660a047490308637ddb4082930e"
    sha256 cellar: :any_skip_relocation, ventura:        "dbe34ad6933d8deec1ed22968e13d3c2570f69264f0be8004fc12bcfc56c6f98"
    sha256 cellar: :any_skip_relocation, monterey:       "71cf904c8b17bb82ecc6abcdefb06b411e30ad94324e0948bfcc86e17ab696d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73d6cbac20d051a45e611bdab5050e750492cb22240223b1aab9d3a1f7326262"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin"vultr", "version"
  end
end