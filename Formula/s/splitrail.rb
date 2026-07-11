class Splitrail < Formula
  desc "Real-time token usage tracker and cost monitor for CLI coding agents"
  homepage "https://splitrail.dev/"
  url "https://ghfast.top/https://github.com/Piebald-AI/splitrail/archive/refs/tags/v3.5.9.tar.gz"
  sha256 "31f5ce991d44d8c31188e9a1b7c9ba9d9774189cd1ffd91994c244c0bce69aa2"
  license "MIT"
  head "https://github.com/Piebald-AI/splitrail.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "626cd00a31b6413d58f5632ed8d981ffff6ee0c1f5b3e7bd453ad0f6e49028df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "850c818e070baaf67a28e3f1663d435509fddbab32a2862d90e7e75e4ebcb433"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f830eeccafbfe8dcab846ad446c55de53b10c28d727947fc1efb1204b2635767"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa7137cd4aca3b2420b78c2e76d3832b27be2a263a623432a1e06b537fe2b1fa"
    sha256 cellar: :any,                 arm64_linux:   "e79db2e016289c1110369f3744035e08d5381badeda58674b4af1e6b13d7ce3c"
    sha256 cellar: :any,                 x86_64_linux:  "b0dcaee9be04eac35846924d2168f61983151489611ac4ecdb8367108fb2bfbe"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/splitrail --version")

    output = shell_output("#{bin}/splitrail config init")
    assert_match "Created default configuration file", output
    assert_match "[server]", (testpath/".splitrail.toml").read
  end
end