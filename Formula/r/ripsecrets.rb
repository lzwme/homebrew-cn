class Ripsecrets < Formula
  desc "Prevent committing secret keys into your source code"
  homepage "https:github.comsirwartripsecrets"
  url "https:github.comsirwartripsecretsarchiverefstagsv0.1.8.tar.gz"
  sha256 "4d7209605d3babde73092fed955628b0ecf280d8d68633b9056d2f859741109d"
  license "MIT"
  head "https:github.comsirwartripsecrets.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "97d6467ccc89611a01d5c6dc308a085cbf3ff6df1d54ddbe7e1c3cf47f860143"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "12e44af7c0222497ed34b983d84e857db3d97acdc89f33d1c378360d8e2662b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ecdf92bc91cda77a1d73866bdfdbc1f454513bb6565be60d55fd33030ca6e0dc"
    sha256 cellar: :any_skip_relocation, sonoma:         "5e61070109ca60cb01955ccccdfad6578594b35749d15faefb93f2333b5cc031"
    sha256 cellar: :any_skip_relocation, ventura:        "19f111f72fb222bc0a3d80e08581af0e41ca9f799935fcaee51d43a8e7e9eae4"
    sha256 cellar: :any_skip_relocation, monterey:       "4f7d5ae55ff9a171700bc7db5a1a5bbf3f0cc18f38afbbcb7c5eab33d593c964"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81f30166cdc076a1b6b9d512250c5c03692a479948c94b9a261358480ddb97a7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Generate a real-looking key
    keyspace = "A".upto("Z").to_a + "a".upto("z").to_a + "0".upto("9").to_a + ["_"]
    fake_key = Array.new(36).map { keyspace.sample }
    # but mark it as allowed to test more of the program
    (testpath"test.txt").write("ghp_#{fake_key.join} # pragma: allowlist secret")

    system "#{bin}ripsecrets", (testpath"test.txt")
  end
end