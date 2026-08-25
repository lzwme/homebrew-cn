class Ttl < Formula
  desc "Modern traceroute/mtr-style TUI with hop stats and ASN/geo enrichment"
  homepage "https://github.com/lance0/ttl"
  url "https://ghfast.top/https://github.com/lance0/ttl/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "4264dffa137a2eb1b8347aeaec08aa9fdc931b17dfaf71e31183e7c02a58a2e6"
  license "MIT"

  head "https://github.com/lance0/ttl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "068910111641e62250c297f4f8fd33cc6d0f87ca046bdb8eec5fb13abcd038b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6954c9892557e85d05b2787abd980fa2e54582372c89978712ef29ff2c996524"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff53954a563f175db3a819cce787b835785bb39db1b519301aa07d816f5a2251"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fa8f811b6a171f6427f2e565448dfd5dc3a9a83a5c59308d1b6a2bcaf75fee7"
    sha256 cellar: :any,                 arm64_linux:   "b23a93e9d83f0d7ac0819c88186d6780ed921da0474af26a3b07af810b18bd9d"
    sha256 cellar: :any,                 x86_64_linux:  "e4606c1c71c5b443491f650fcbcf80fb5ac71ee2f1798b5975ddb3e5ca62b469"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "ttl", shell_output("#{bin}/ttl --help")
    assert_match "Insufficient permissions", shell_output("#{bin}/ttl 127.0.0.1 2>&1", 1)
  end
end