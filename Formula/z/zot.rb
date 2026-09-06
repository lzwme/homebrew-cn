class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.64.tar.gz"
  sha256 "3219c366a3e1e9b693ee940dc499ca12f4065aee3090b9d68458513c51186ca2"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00d8c17459fde967303ae73b4522eab01063c01ebd67aff5b24d1cd91b783880"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00d8c17459fde967303ae73b4522eab01063c01ebd67aff5b24d1cd91b783880"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00d8c17459fde967303ae73b4522eab01063c01ebd67aff5b24d1cd91b783880"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79e466f69da9f0230edc572a37a6fd263924954269bb232373daf83d113da7b9"
    sha256 cellar: :any,                 x86_64_linux:  "20429da316bad3addbce8704a0eaf152ba8c5a0003c8f8aebd21ac8fd550b08a"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/zot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zot --version")
    assert_match "zot: no credential for anthropic", shell_output("#{bin}/zot rpc 2>&1", 1)
  end
end