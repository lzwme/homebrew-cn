class Exercism < Formula
  desc "Command-line tool to interact with exercism.io"
  homepage "https:exercism.iocli"
  url "https:github.comexercismcliarchiverefstagsv3.4.2.tar.gz"
  sha256 "5d9fd465d7b5407ea11dd735cde892ac8a8a3f8f26c1b16a8d4718d2217e8cab"
  license "MIT"
  head "https:github.comexercismcli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "664d1aa78cbd0ea65ce1e6933595c54cdf3dc4bb310e8ca6bf5efe7b1784a2c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "664d1aa78cbd0ea65ce1e6933595c54cdf3dc4bb310e8ca6bf5efe7b1784a2c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "664d1aa78cbd0ea65ce1e6933595c54cdf3dc4bb310e8ca6bf5efe7b1784a2c4"
    sha256 cellar: :any_skip_relocation, sonoma:         "3963e2c7fd6173846b8ea2977ba78d2f1fb6a2e4000f3107db90e887a0738821"
    sha256 cellar: :any_skip_relocation, ventura:        "3963e2c7fd6173846b8ea2977ba78d2f1fb6a2e4000f3107db90e887a0738821"
    sha256 cellar: :any_skip_relocation, monterey:       "3963e2c7fd6173846b8ea2977ba78d2f1fb6a2e4000f3107db90e887a0738821"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4aed748ceda39b93eb9bcc8663c222eb8a9c03639a206c8ccbbb5d1b7eab2a60"
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