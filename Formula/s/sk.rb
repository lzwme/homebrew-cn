class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://ghfast.top/https://github.com/skim-rs/skim/archive/refs/tags/v5.7.2.tar.gz"
  sha256 "38dcd1bf756e619b42f076db0ffbc95fce11bf81b411a538f75556af5d0fd2a7"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c4d1ce775f4541b13b0d71ec8fcad8535ce3d80649b41f4ff5be1763f61de629"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4445e1ba87d41b963236c8fd976bb90e51e4843447b40416a91865b6e4962c98"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c32731f9c257ea90e845df5c8cb323877602b6237a5ccc28467548094ea15c65"
    sha256 cellar: :any,                 arm64_linux:       "f0bbdbfa9eec139926a417e6f4ebb211ba26d96ef055e6d0eebf83c06db5812a"
    sha256 cellar: :any,                 x86_64_linux:      "f77458c9db416bb96e43670f100d9d8331beaec020446c78a96a196b02cbc4b0"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"sk", "--shell")
    bash_completion.install "shell/key-bindings.bash"
    fish_completion.install "shell/key-bindings.fish" => "skim.fish"
    zsh_completion.install "shell/key-bindings.zsh"
    man1.install buildpath.glob("man/man1/*.1")
    bin.install "bin/sk-tmux"
  end

  test do
    assert_match(/.*world/, pipe_output("#{bin}/sk -f wld", "hello\nworld"))
  end
end