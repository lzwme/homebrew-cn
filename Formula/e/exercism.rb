class Exercism < Formula
  desc "Command-line tool to interact with exercism.io"
  homepage "https:exercism.iocli"
  url "https:github.comexercismcliarchiverefstagsv3.5.0.tar.gz"
  sha256 "819ac86c397782c8227ae443418c46ce86bfd0bd4ee6c67175102a7e67ba3010"
  license "MIT"
  head "https:github.comexercismcli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b326e9377a523fc5cf38c02c8c2c530390f07e16d6ee9a2c3b1789b1cd832eb4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b326e9377a523fc5cf38c02c8c2c530390f07e16d6ee9a2c3b1789b1cd832eb4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b326e9377a523fc5cf38c02c8c2c530390f07e16d6ee9a2c3b1789b1cd832eb4"
    sha256 cellar: :any_skip_relocation, sonoma:         "2977c703e203bf524d7355052c18e68cb407af9c9e6f0565e87d5f15449d8b1e"
    sha256 cellar: :any_skip_relocation, ventura:        "2977c703e203bf524d7355052c18e68cb407af9c9e6f0565e87d5f15449d8b1e"
    sha256 cellar: :any_skip_relocation, monterey:       "2977c703e203bf524d7355052c18e68cb407af9c9e6f0565e87d5f15449d8b1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba81bfff53fcd769e42525d6ebec0901a8e395ffd4a831464cb0540e0408c385"
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