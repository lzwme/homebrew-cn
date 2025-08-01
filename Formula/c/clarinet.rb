class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://www.hiro.so/clarinet"
  url "https://ghfast.top/https://github.com/hirosystems/clarinet/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "f9e3d0926d9de79ca0f8a432354b91cc58c2596ab9d8a5504ddaf3dc9eb26098"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0519847e02a4bf582bad84694055e6cd6ec84f9f570df20518c519775c623786"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b2c35d478c2f303dee002296ce67bb928bae0390d8da48c1caf6c2ff4b42f92"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "15a0a0dd1deeb41380c26a7c1fc7efb24f398c60eafe2cdbc7705bb7ab978cf4"
    sha256 cellar: :any_skip_relocation, sonoma:        "b43125b274c012508bf106afb91c272437eb32edf0a93c6e3ffe5b295970d8d3"
    sha256 cellar: :any_skip_relocation, ventura:       "4525f0f2949fe76b67dd9807680a6792a0dc2b9b3f656dba80d0d38f35d7d578"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "464a675e78091b34c6410697c84aabe453cb08bb3772b6aa92ea8c1ebc536f8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fcd8ca9eacab621684fe2c3d652805ca4d5dcc22e7e7ba0d3b2a75ec8e4c15f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "components/clarinet-cli")
  end

  test do
    pipe_output("#{bin}/clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end