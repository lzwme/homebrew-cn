class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://github.com/always-further/nono"
  url "https://ghfast.top/https://github.com/always-further/nono/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "2e55a82ee616f67b92c56466de3f3a6e162b5dec63f52839b1b1c8fce2a8dde3"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb082b12badf3aaee0ab55584ff263d3ffc2e67c78a24b2ef3c2610f329bc851"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bcdaa77281b0e7427fb2ffa9f554a0bea2a6c7ba178c0f08f6cca41327e4f95e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ce0783f417fe5b652a67c63425c5cd59ded0022b1fd94980828be244bb4a722"
    sha256 cellar: :any_skip_relocation, sonoma:        "3232dc1fa980f910aafa85bad25de805d478032c08f1866d1dc3821cd4e1982b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eab946787cbb96306d53bf914e6af2bc6558c065764f56c3de33dd5ba3cd829c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8419e6e48f9e952998095fd5967a42bf4af0c079c34c8596a95e8937445f3ba2"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/nono-cli")
  end

  test do
    ENV["NONO_NO_UPDATE_CHECK"] = "1"

    assert_match version.to_s, shell_output("#{bin}/nono --version")

    other_dir = testpath/"other"
    other_file = other_dir/"allowed.txt"
    other_dir.mkpath
    other_file.write("nono")

    output = shell_output("#{bin}/nono --silent why --json --path #{other_file} --op write --allow #{other_dir}")
    assert_match "\"status\": \"allowed\"", output
    assert_match "\"reason\": \"granted_path\"", output
  end
end