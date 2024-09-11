class Exercism < Formula
  desc "Command-line tool to interact with exercism.io"
  homepage "https:exercism.iocli"
  url "https:github.comexercismcliarchiverefstagsv3.5.1.tar.gz"
  sha256 "e20e30ea0acc8a47d67d577e13af87fc7a189f133b0b9f092594a7b65993166b"
  license "MIT"
  head "https:github.comexercismcli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "fde71458363213bd329bb3c1afb7d7f148c82975ae96f7d2b1594f32fa5e6052"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2bdb929be6c80961d14e4c1230c2c91304a7a914accce12887edee61fd7586e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2bdb929be6c80961d14e4c1230c2c91304a7a914accce12887edee61fd7586e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2bdb929be6c80961d14e4c1230c2c91304a7a914accce12887edee61fd7586e4"
    sha256 cellar: :any_skip_relocation, sonoma:         "00ef18f587cdb3fda94f54cc962fdc74db15a46be81ae56e5572782714ff0973"
    sha256 cellar: :any_skip_relocation, ventura:        "00ef18f587cdb3fda94f54cc962fdc74db15a46be81ae56e5572782714ff0973"
    sha256 cellar: :any_skip_relocation, monterey:       "00ef18f587cdb3fda94f54cc962fdc74db15a46be81ae56e5572782714ff0973"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db888fae539168d6ff92435349ee9d8715c40f37368d340877306a4933527a6f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "exercismmain.go"

    bash_completion.install "shellexercism_completion.bash"
    zsh_completion.install "shellexercism_completion.zsh" => "_exercism"
    fish_completion.install "shellexercism.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}exercism version")
  end
end