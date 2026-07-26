class Gittype < Formula
  desc "CLI code-typing game that turns your source code into typing challenges"
  homepage "https://github.com/unhappychoice/gittype"
  url "https://ghfast.top/https://github.com/unhappychoice/gittype/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "94f701fd87824c2d1ecb2b9e76e7d9665eb26eab1c97795d23213d12027d6407"
  license "MIT"
  head "https://github.com/unhappychoice/gittype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e82879bd378c43432d67c4b77231acb056209d258270401f2788cc30b3d470bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19fdb6c5434a8d7df53803a6026f49e79699d51e5f9628ae3a3e9ed5ce9f651f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5aab8c02febfc0243dd69e4f9c569b30f5933e701b3f3a445dec092b1000d68d"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c2a7e5c943142a78f9ad94b0cf0b9992cf9441ffc9b7be31dc3184f5c094519"
    sha256 cellar: :any,                 arm64_linux:   "2aa00b27615fcc094e8997018f28f80384dd0756fc5476d10f55c2bb04fe20b7"
    sha256 cellar: :any,                 x86_64_linux:  "bdeba194be01ae6b0e1f6f7a17785469ca23208ed773d45ae7916d3b5d0438e8"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gittype --version")

    %w[history stats export].each do |cmd|
      output = shell_output("#{bin}/gittype #{cmd} 2>&1", 1)
      assert_match "command is not yet implemented", output
    end

    output = shell_output("#{bin}/gittype repo list 2>&1", 1)
    assert_match "Error: Terminal error: Not running in a terminal environment", output
  end
end