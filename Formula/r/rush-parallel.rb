class RushParallel < Formula
  desc "Cross-platform command-line tool for executing jobs in parallel"
  homepage "https:github.comshenwei356rush"
  url "https:github.comshenwei356rusharchiverefstagsv0.5.5.tar.gz"
  sha256 "88b3f15d775ecf6503f498b4782636ec8fc451e60954fab66c6f7c885f738a61"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "49b47b7b6f7c7360f80dd98d94ede521f5f3e955de1a496eee277e6e063c621e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9bf04d91653c5f3c4a2ce651cfbf27be263ff96ea68881b713bce881085afc24"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d82fc7edfd5fe85999dd88d2da90ffda6584b6b642a9c0dd21f90cf85263d8dc"
    sha256 cellar: :any_skip_relocation, sonoma:         "89f48efd4a6ab32f445c7ba26218fda53f5d8a10b0cba84efe3700883b0fc63e"
    sha256 cellar: :any_skip_relocation, ventura:        "00ba0d5809bc49a90213eb5b1d0200f1349378e3c0a8cec05787d8f591ae4cb7"
    sha256 cellar: :any_skip_relocation, monterey:       "ed9e0c69f9ed50ff143a53b04d171fef97a750350db9fda94077eb27fcb62db9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fe843f988faaa2623fe3590a72f4b2c8aec8bc736162263420e2a0d597ec1fa"
  end

  depends_on "go" => :build

  conflicts_with "rush", because: "both install `rush` binaries"

  def install
    system "go", "build", *std_go_args(output: bin"rush")
  end

  test do
    assert_equal <<~EOS, pipe_output("#{bin}rush -k 'echo 0{}'", (1..4).to_a.join("\n"))
      01
      02
      03
      04
    EOS
  end
end