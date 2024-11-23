class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https:github.comlotaboutskim"
  url "https:github.comlotaboutskimarchiverefstagsv0.11.11.tar.gz"
  sha256 "14ed464abf853e474065ad538f20d9c9874db71189b4522e2f4552559711e21a"
  license "MIT"
  head "https:github.comlotaboutskim.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c23255422ed5e5166b56bbbad681f6fd0ff2d005f090f8860e78677a1b9360d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "769e0a5438a6efe824a049f1993a70b71f9dbb7c12fccc5ccb985345f94d08db"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2e5b4485f237137a66d84da8aa92d7f01cabb680310fdfc50e5514ec0c51ec2e"
    sha256 cellar: :any_skip_relocation, sonoma:        "359c7245277871761f4c467888838e64f506ed0ba0374b43fa7b7aac78f651f0"
    sha256 cellar: :any_skip_relocation, ventura:       "e7287288f99dac97e317a425ae84d8bfeb308793cb436a471e5c0c7d60cc36aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72101d040476e4a97afe0172c9d3007ba1a44cc68c4ad85eb25e2c0cf580211b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "skim")

    pkgshare.install "install"
    bash_completion.install "shellkey-bindings.bash"
    bash_completion.install "shellcompletion.bash"
    fish_completion.install "shellkey-bindings.fish" => "skim.fish"
    zsh_completion.install "shellkey-bindings.zsh"
    zsh_completion.install "shellcompletion.zsh"
    man1.install "manman1sk.1", "manman1sk-tmux.1"
    bin.install "binsk-tmux"
  end

  test do
    assert_match(.*world, pipe_output("#{bin}sk -f wld", "hello\nworld"))
  end
end