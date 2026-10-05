class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://ghfast.top/https://github.com/skim-rs/skim/archive/refs/tags/v5.7.4.tar.gz"
  sha256 "47934e9ff95935850d6cd7771bfbaf8d33a84ef5b80e1ab92d9b0e8a2812b3ef"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "83a3bd0242e77ae5a3eb9314d3b93b107d5e41e1a4e308c474dcd0e4d52295a0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8d6e21e6faef4d8c7fb4491e867a8684ca07f39db90cff4f4417146f9a19d663"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "56d234d1cace3e905f1000db2fbfc5a7875921e4b46c4c4b3706145af72f4724"
    sha256 cellar: :any,                 arm64_linux:       "9bebc0bf9cbced2b86064f5d40b2ad1bc75651103d72f7f587f05937598be2ce"
    sha256 cellar: :any,                 x86_64_linux:      "b9242aa3bd55257dba0503e126e8f1cf5c5e7c852e8d2e767d2a497b0b39b41c"
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