class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https:danielmiessler.compfabric-origin-story"
  url "https:github.comdanielmiesslerfabricarchiverefstagsv1.4.200.tar.gz"
  sha256 "63f95fd54844d0ea1f59ab2b79d86854129378d6a971a85a25a546e276550db8"
  license "MIT"
  head "https:github.comdanielmiesslerfabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "abe57acd2cbda56e881a76fbc0ad101f2ce0ef60efa45e8d26f68bccf78eb258"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abe57acd2cbda56e881a76fbc0ad101f2ce0ef60efa45e8d26f68bccf78eb258"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "abe57acd2cbda56e881a76fbc0ad101f2ce0ef60efa45e8d26f68bccf78eb258"
    sha256 cellar: :any_skip_relocation, sonoma:        "dec0d95950b473d0b29a9772d3c4fbd22201bdc060869d088bc55d4d96461ea0"
    sha256 cellar: :any_skip_relocation, ventura:       "dec0d95950b473d0b29a9772d3c4fbd22201bdc060869d088bc55d4d96461ea0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5972f40a04ca05f9a2debf29091ac54e3cf5c986c7963af0f0d9cf84b2a3a043"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}fabric-ai --version")

    (testpath".configfabric.env").write("t\n")
    output = shell_output("#{bin}fabric-ai --dry-run < devnull 2>&1")
    assert_match "error loading .env file: unexpected character", output
  end
end