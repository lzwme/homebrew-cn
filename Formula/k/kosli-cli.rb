class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https:docs.kosli.comclient_reference"
  url "https:github.comkosli-devcliarchiverefstagsv2.7.4.tar.gz"
  sha256 "9b094fe528eeb0ded9dd4560525e5e04279725e7424c4077c7195bbb39870770"
  license "MIT"
  head "https:github.comkosli-devcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "419a92f5513e3168d728a15df3cb89ca8c5ebc5776f1f6d35f7784dc429d9b56"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0579724d9690b80d0f78b1fbe804ba79210f48a1a20b6fc96b9e0f8370a9ee25"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dff25fb75c93798d9df555ee29e2dfae9acd1ff1cf1cca932d5fa994eae239cb"
    sha256 cellar: :any_skip_relocation, sonoma:         "080414bcbbf8dc5d3fcd1b7c1cb6644abb443f72528c67d2ead459c225fc70ac"
    sha256 cellar: :any_skip_relocation, ventura:        "c66d44648a47037387dc8b8ab06e9e50a414e13f9c27c2d7cda746e54dc976d3"
    sha256 cellar: :any_skip_relocation, monterey:       "cf022960721a4da4fda0b0e4f87cc579174ecf645710f91569d1e55dc8422413"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b4f660fcd91650bec4f858a90c949b25d20c73b26bee71f049a8dfbc18af5b0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comkosli-devcliinternalversion.version=#{version}
      -X github.comkosli-devcliinternalversion.gitCommit=#{tap.user}
      -X github.comkosli-devcliinternalversion.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin"kosli", ldflags: ldflags), ".cmdkosli"

    generate_completions_from_executable(bin"kosli", "completion", base_name: "kosli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}kosli version")

    assert_match "OK", shell_output("#{bin}kosli status")
  end
end