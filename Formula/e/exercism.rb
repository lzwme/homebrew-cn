class Exercism < Formula
  desc "Command-line tool to interact with exercism.io"
  homepage "https:exercism.iocli"
  url "https:github.comexercismcliarchiverefstagsv3.5.4.tar.gz"
  sha256 "58dcd1a62552466b6fa3d3ad62747b1cfeafae5fca3b511c08f5efa9af22539c"
  license "MIT"
  head "https:github.comexercismcli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f9da30002c7198b9d75d86c774cc1963e62c62924bba5e541db4e2d5457bb62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f9da30002c7198b9d75d86c774cc1963e62c62924bba5e541db4e2d5457bb62"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9f9da30002c7198b9d75d86c774cc1963e62c62924bba5e541db4e2d5457bb62"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9666dfef34c3e6fe8fe9dd1fe221f6dce00d86e0c99a820b8aac229875beeec"
    sha256 cellar: :any_skip_relocation, ventura:       "b9666dfef34c3e6fe8fe9dd1fe221f6dce00d86e0c99a820b8aac229875beeec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8069217404dd1a17c578009d1e01cd8f021710898257a41d5ab57c19caab60b1"
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