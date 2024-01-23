class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https:coder.com"
  url "https:github.comcodercoderarchiverefstagsv2.7.1.tar.gz"
  sha256 "9c1d4b18f9f55cb45e6a51f55d0649781a2f4e07e9a0aea5368850ca0db14d1c"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2c2d1e4f60a9bb9bcac12d514c7cc8c6da9b41c2e362ceb6e70e631f571adaab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c66b32d1b9d7b9d16988482d7c3ca7acff95bb244687e641b7d8b6fdcd1ba302"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09b5e9e8425c74625e4c4092d5059340aaf23fabb3a2fb786503627aa057b005"
    sha256 cellar: :any_skip_relocation, sonoma:         "af5ea6078e8da2cd6bc06359ae4ac92ce46ef32d63c4c64f1a38b10b638e8396"
    sha256 cellar: :any_skip_relocation, ventura:        "87ed4a991ee3fd67911ad8056724d89506caad79e4b14fbc7ff09cdc857da1af"
    sha256 cellar: :any_skip_relocation, monterey:       "060d8acceb906b6d1b5a176748e7d7f00c44b3b7b130309d3985b7f1b6b20d14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4dacc2d76f97a72dd41e7c7a9a38c26a19305e6df9a5d2e02131f27c3572d258"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comcodercoderv2buildinfo.tag=#{version}
      -X github.comcodercoderv2buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "slim", ".cmdcoder"
  end

  test do
    version_output = shell_output("#{bin}coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}coder netcheck 2>&1", 1)
  end
end