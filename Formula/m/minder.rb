class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https:minder-docs.stacklok.dev"
  url "https:github.comstacklokminderarchiverefstagsv0.0.21.tar.gz"
  sha256 "cf4679938a37d64a1c9e16bd9862f7347ac532a8b8254f780508bc692460ed3a"
  license "Apache-2.0"
  head "https:github.comstacklokminder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fbf38b317dcfb030a1e1fa206a7a1f749dc86b7cf10d1d378030d218fd8c0785"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e4baf5da85db493a5c87854fcb7414572c2122e6cfead4984caa0db9d2e47a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0420eb9ccaf9cb0c315243ac940835ad5a15a30b197b62be45f32ec8b728ab5"
    sha256 cellar: :any_skip_relocation, sonoma:         "79a0d56178ab075e019571a5830ef4fa634edbfac4e274ac26c22cf03028b022"
    sha256 cellar: :any_skip_relocation, ventura:        "fa8d3c37c6e4286777486447d128bd040bd6b845e12a516d42906b4f41f0c115"
    sha256 cellar: :any_skip_relocation, monterey:       "d8e85b64424f51bafbe6b84e542ec40952d25dfa89707bb4477dfee88885aac5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae28ae139a83760ff70989bd536e0b5bfc6fa81a0a88be8f6d84dfaaaa87782a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comstacklokminderinternalconstants.CLIVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), ".cmdcli"

    generate_completions_from_executable(bin"minder", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}minder version")

    output = shell_output("#{bin}minder artifact list -p github 2>&1", 16)
    assert_match "Details: Unauthenticated indicates the request does not have valid", output
  end
end