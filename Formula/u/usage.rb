class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https:usage.jdx.dev"
  url "https:github.comjdxusagearchiverefstagsv0.6.0.tar.gz"
  sha256 "a0bc217967d7a42f1d7dccf3290e23ed4d18b0253a3e7fc9039b0a020ce17137"
  license "MIT"
  head "https:github.comjdxusage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a6efc3ba169d35bf941d841cf44fd9a6ebcb968aaf49a978e69bd5049fdf750"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a7daba7248b74735130c05a9696b819148a21595c7d0d47d8c31dc0b6fceb33"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a7f76956e440b146c5d7a4a14299d60e70625128628d65d49920f2cf5039d461"
    sha256 cellar: :any_skip_relocation, sonoma:        "a245231ddb6aaecfe892cf3fdc3ff6a23c099dd221c6b42d346eab1132d1d314"
    sha256 cellar: :any_skip_relocation, ventura:       "c11b419854e30e8e5a5b61f2bf256b6f7c764ef4579701011ad5214d3417547b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c631f7d30af5efee622b4dbdf188265c817046d4518ea4361bd5175a958a38f0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match "usage-cli", shell_output(bin"usage --version").chomp
    assert_equal "--foo", shell_output(bin"usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end