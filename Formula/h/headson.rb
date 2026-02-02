class Headson < Formula
  desc "Head/tail for structured data"
  homepage "https://docs.rs/headson/latest/headson/"
  url "https://ghfast.top/https://github.com/kantord/headson/archive/refs/tags/headson-v0.16.0.tar.gz"
  sha256 "0a1b5e01a379a234968d87548c79d2d14031670a4790c2e5bb3d99dda8297108"
  license "MIT"
  head "https://github.com/kantord/headson.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ddf7d66ed460f66ff5fb036af8e381593e11a0936882e763913974cc1d766c66"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e3a21d25858dbd44bf6b2178cc78fa12c653519ef2de0620be9999db65a48a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f12e0933186d8c0b18cffa5afe5674294a5a0196d8ad9497d19bba4603e578e"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ff9b60bbe8c3854721c1a2500752f103e8d7db200766e3d96154273622b5854"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a831027dd0203695a9855e60f3d301b00143b24220bf03bf4ae82a150d5f205c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb0a7875db3f49c7f5a125c77fdeae1e04ee79104c6ebc3c8aee6928dae70b82"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"hson", "--completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hson --version")

    (testpath/"test.json").write '{"a":1,"b":[2,3]}'
    assert_match '"a":1', shell_output("#{bin}/hson --compact #{testpath}/test.json")
  end
end