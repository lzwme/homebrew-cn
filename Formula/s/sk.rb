class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://ghfast.top/https://github.com/skim-rs/skim/archive/refs/tags/v5.1.3.tar.gz"
  sha256 "e348fa7690c9e1fe33ecf8f162324101214a658082e887e9372dd264dbea6f48"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0fc983494eedecd92c4fdc914e809331a7e307c706662525dc894c72d926ddf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29d5cbdc9edefd0f295c37528dfcf46ce4f5709ba4aeaaab4aab95562f3a7a68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1de28e84a90cfa9ce2cc67b49efaff7382537886514c7e73862d635036a141b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5b964c81fc186a3ff9a6b7c11312231b2e00f2b052caecc640f93044ff8b22e"
    sha256 cellar: :any,                 arm64_linux:   "bc950bdeac8b4a300afa4b2bcf9bd8bff496bc5bd245183f788bed469003f4cf"
    sha256 cellar: :any,                 x86_64_linux:  "0334dc157e84242dfc67be137b84eee97606b9e5e30d75d9ef2408c483ecd38f"
  end

  depends_on "rust" => :build

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