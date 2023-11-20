class Xh < Formula
  desc "Friendly and fast tool for sending HTTP requests"
  homepage "https://github.com/ducaale/xh"
  url "https://ghproxy.com/https://github.com/ducaale/xh/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "3d4f5ac1c7ead00891c85a569df452d583d3c10df61f6ceb3fb58b5fef2ffdbc"
  license "MIT"
  head "https://github.com/ducaale/xh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "92d71d05097951df03a994a8022394f3deeb63d397101085aa759e3e7a958d4d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dcfa968041b517731372d15fc4f1b47b4d26a18f84ab9cabf0110bf0b989a532"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6aa752350bd95021ffa696cb26369b7b5e361c78f680075bdf858f48134c3771"
    sha256 cellar: :any_skip_relocation, sonoma:         "25d3876ba3f120eaf8fb286d95ce8ac2ed81c2aa0af86057786076e0291dfd42"
    sha256 cellar: :any_skip_relocation, ventura:        "4d3e6f509336d47609aebdc1c4ee3e4111f724f27b4dda916699beed0b8c925b"
    sha256 cellar: :any_skip_relocation, monterey:       "040bbb374e87f2b0d08a1109792996a7ed7ed818452f583cf57870748216c147"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84b5e70199066b8dc4d38d36c89266a68f7055d51e2e1801e6997920bf610fda"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    bin.install_symlink bin/"xh" => "xhs"

    man1.install "doc/xh.1"
    bash_completion.install "completions/xh.bash"
    fish_completion.install "completions/xh.fish"
    zsh_completion.install "completions/_xh"
  end

  test do
    hash = JSON.parse(shell_output("#{bin}/xh -I -f POST https://httpbin.org/post foo=bar"))
    assert_equal hash["form"]["foo"], "bar"
  end
end