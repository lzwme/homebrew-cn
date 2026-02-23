class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://watchexec.github.io/"
  url "https://ghfast.top/https://github.com/watchexec/watchexec/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "4d39adf3c9b7e4a0e2647bdfede330b9be709b4d5e3fcb3b847fcaa761b3daf8"
  license "Apache-2.0"
  head "https://github.com/watchexec/watchexec.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:cli[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1520409cd88b192d6eca86f1fa385a63681d3f9e27d82fbfb505a985f1c28c19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c2c9e70de7a05f23ad9316acdaa6e24ad59c67d7efa875394e25ef5ac5e9829"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7dd796da15efd243818f5afa8d622bdaa70af26a63d32436c5b04f382289c62d"
    sha256 cellar: :any_skip_relocation, sonoma:        "25f84b6022616f40f4a789890775a2e9f1d263361abadc78af37687fa597efaa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04b88ed5bac1d93c5690ebeec90cabb22f4afbe3e4c3b4aba928b88a6e96bf53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28dd45cbeeb37c366bc2891adbd5ffcdd78b212aa0722efd966125845a96fa8d"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")

    generate_completions_from_executable(bin/"watchexec", "--completions")
    man1.install "doc/watchexec.1"
  end

  test do
    o = IO.popen("#{bin}/watchexec -1 --postpone -- echo 'saw file change'")
    sleep 15
    touch "test"
    sleep 15
    Process.kill("TERM", o.pid)
    assert_match "saw file change", o.read

    assert_match version.to_s, shell_output("#{bin}/watchexec --version")
  end
end