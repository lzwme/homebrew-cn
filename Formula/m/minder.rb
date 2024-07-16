class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https:minder-docs.stacklok.dev"
  url "https:github.comstacklokminderarchiverefstagsv0.0.55.tar.gz"
  sha256 "5602490647a367b594671964d76a9bdf6cdd563a59220867801c7c7037ebe49b"
  license "Apache-2.0"
  head "https:github.comstacklokminder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a4132b386ffc0869db8f36836c4ef599494c83b70cf94320cb33a1195663c7b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c2a4bca2062585245ba87c56124b40c2c3f5b835084f9147d5af5240f6d50695"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "258ce5867c44b0af7589ab9627ec8ee279e3dedbc83e809c085a0d91feb7e7d7"
    sha256 cellar: :any_skip_relocation, sonoma:         "bc19245b5dfa4e958f7e7700c8665205185d330ebea37f9d364bbec6aaf4b857"
    sha256 cellar: :any_skip_relocation, ventura:        "12d40ebae402a9a1991c5190d51839a990343def22b265e355303b21c39a710a"
    sha256 cellar: :any_skip_relocation, monterey:       "a6f4115b62a356916a809a521b17a3c1d8c64609e5fba8a163db28d3112978e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13d65f625e0c943d23bdb44daaec586ffe14d397af3841732c6ca68c9821514f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comstacklokminderinternalconstants.CLIVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdcli"

    generate_completions_from_executable(bin"minder", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}minder version")

    output = shell_output("#{bin}minder artifact list -p github 2>&1", 16)
    assert_match "No config file present, using default values", output
  end
end