class Prefligit < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prefligit"
  url "https://ghfast.top/https://github.com/j178/prefligit/archive/refs/tags/v0.0.17.tar.gz"
  sha256 "ddac999640e91327d084ea0186ae334f0ec8151177d816d5b6b6ff59030feb69"
  license "MIT"
  head "https://github.com/j178/prefligit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef9616dfd2479417bb006d76a13d263e337829cc8f4c23cc751546d67295f3e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab04bea6d88b5d72285f42a63bc68ce0d8827fbd205c3f9f62bba87b3fd8c4d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5154899261b501b25c104d586a59ff3bb009cf7b0fb9ef3f574aacf992af4139"
    sha256 cellar: :any_skip_relocation, sonoma:        "d388ff1a44e85208a14cfd95b1cc34ae7183242e9fba728c57670eb2be3d2cf3"
    sha256 cellar: :any_skip_relocation, ventura:       "cf827e26d3f67fe05d99d0a67b5d341e3794a179c96374c38dd3aefb75f0a7d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa0e451700cabc8998f8147c72c1b6c04f4c1a55f1cda88d9fe14d1c3ef9195b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48dca54047031fc753538e2922f1916bee5117b47bd45615295a2266c4c8cb8f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"prefligit", "generate-shell-completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prefligit --version")

    output = shell_output("#{bin}/prefligit sample-config")
    assert_match "See https://pre-commit.com for more information", output
  end
end