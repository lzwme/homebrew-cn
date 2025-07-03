class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv1.16.0.tar.gz"
  sha256 "8c497c7d126ff3e942fcb6cd09b43e5d4b31d8529d06bbfa679bc967de11bd48"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19361ec59cf390bd3985a378ab9137c75091f763c74efbd74a3a23e7e56d5af9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "671224e170e246a0c6aa7928229158132a40a3297724e035d11366528653848c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "69d3f6d3bf8924f70d91517eba74b1027fa667caebf7a04fd114ef244f8efe3b"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8cfe22b5bb231c642e72253d6c15754ad2d5af6441dde47013b8493966fc299"
    sha256 cellar: :any_skip_relocation, ventura:       "6c34eb031d37d7d77b082dce9058f3ddfb5552b0800faa9fbde63aab56997268"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0732336dc37a8cd803c5a33b3dd68d33adda854e0645263593ad72d606867246"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comchainloop-devchainloopappclicmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin"chainloop"), ".appcli"

    generate_completions_from_executable(bin"chainloop", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}chainloop version 2>&1")

    output = shell_output("#{bin}chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end