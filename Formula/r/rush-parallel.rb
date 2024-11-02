class RushParallel < Formula
  desc "Cross-platform command-line tool for executing jobs in parallel"
  homepage "https:github.comshenwei356rush"
  url "https:github.comshenwei356rusharchiverefstagsv0.5.7.tar.gz"
  sha256 "07d0fc8b4247625a8a62dcd7e337a9bc16f7e25a5ced7e96ee08cdc88fbb2dc6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b19b561b17ee16f2946bce38dd6ef72155d4ab8be74e7bd3a8beb04b3f6289ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c94523d738e9056eacc4ca23b2ce0df8edd92ba41b5764f18de15f4c7834712b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "61a1adac65b0a06a60888e851bb9a68cbaf4f04e3c2149d47112fc6ee63bf237"
    sha256 cellar: :any_skip_relocation, sonoma:        "9de7203510209e835862f7ac42e8bc2ef0c5d31a15c12457c78023a80b05b2f1"
    sha256 cellar: :any_skip_relocation, ventura:       "817896f3adb411f9cba80905a2b0abe37e9682aa9a1cf4a450ff092dfdb5c5f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a3bc3a16c056b10512c7ca52b26f05168e661cc7ae8ee16e81cd965ba775c19"
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