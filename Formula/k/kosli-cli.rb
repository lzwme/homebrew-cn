class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https:docs.kosli.comclient_reference"
  url "https:github.comkosli-devcliarchiverefstagsv2.10.1.tar.gz"
  sha256 "25efc3e31a066d8b2102472a15150ade9bc78c11e369101c3971c2e299016752"
  license "MIT"
  head "https:github.comkosli-devcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "06008cabc3b2c32a23ac0a5c3c94e3209a530124866f7a9b716cbdfe9a2d37a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f8648fabf8c40e9dd8dcb169c02bb6df84ed1b094af48f3a26d2b89fd5e9198"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1e9e4cf954566d314e8080879dec0b4bbadf578e4add2ee63873df106b72938"
    sha256 cellar: :any_skip_relocation, sonoma:         "90f4903573368b2d1fd30c1ce6e244142e696cfc14723c7d706b9fed01e80beb"
    sha256 cellar: :any_skip_relocation, ventura:        "1b8e4f36da4f2dcbd066122f269d229c865ebe5c971cdae71496e1b9a49ff76e"
    sha256 cellar: :any_skip_relocation, monterey:       "4a280772368cd672f0f88653107b216e4aa539f3f8585a66b92cf730b186bd03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2b2d4ae13543e4f69a9f329b59356d476d41ce103f9757d3e4a4e7f4d698afb"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comkosli-devcliinternalversion.version=#{version}
      -X github.comkosli-devcliinternalversion.gitCommit=#{tap.user}
      -X github.comkosli-devcliinternalversion.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin"kosli", ldflags:), ".cmdkosli"

    generate_completions_from_executable(bin"kosli", "completion", base_name: "kosli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}kosli version")

    assert_match "OK", shell_output("#{bin}kosli status")
  end
end