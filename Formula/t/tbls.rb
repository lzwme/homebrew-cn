class Tbls < Formula
  desc "CI-Friendly tool for document a database"
  homepage "https:github.comk1LoWtbls"
  url "https:github.comk1LoWtblsarchiverefstagsv1.79.2.tar.gz"
  sha256 "870866a6fa5cd3bccca54961be7caea5aac5a69301ad404ccdd13cd99e0e7f6c"
  license "MIT"
  head "https:github.comk1LoWtbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45609a5bdfb453d9dabce1a61d460a469e2dd4b26c097deb5dc3bb1773d86e47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f4b74435016f3e10950472a47f9fe5b9180483ad82566d304fc94c51772175b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d98c89ef1176ce4889d54fe594262f6a79fa18ac7454e8967583be2726e4d62f"
    sha256 cellar: :any_skip_relocation, sonoma:        "1af246a37e4df0184f684e8bf7e5b9cce7fae1660f86841c7d2dde3fdb03e9ba"
    sha256 cellar: :any_skip_relocation, ventura:       "f0ef844988b25594b76006f959316d550397c0a1605119f96cbdb284a41f23fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a8be1b069f0808299052311d68b73972c8538c18294cb0d61adefd6a7dbbcca"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comk1LoWtbls.version=#{version}
      -X github.comk1LoWtbls.date=#{time.iso8601}
      -X github.comk1LoWtblsversion.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"tbls", "completion")
  end

  test do
    assert_match "invalid database scheme", shell_output(bin"tbls doc", 1)
    assert_match version.to_s, shell_output(bin"tbls version")
  end
end