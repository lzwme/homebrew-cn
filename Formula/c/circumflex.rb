class Circumflex < Formula
  desc "Hacker News in your terminal"
  homepage "https://github.com/bensadeh/circumflex"
  url "https://ghfast.top/https://github.com/bensadeh/circumflex/archive/refs/tags/4.2.tar.gz"
  sha256 "3ae8e670e9d546437a074d5fc5c1ab0bd7f81609fd49880729d9d3f5d0988eaa"
  license "MIT"
  head "https://github.com/bensadeh/circumflex.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd04f37d5111280fe5bd63a35cf4b8232d609adb8fe21e0e87a9a6f90497264f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd04f37d5111280fe5bd63a35cf4b8232d609adb8fe21e0e87a9a6f90497264f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd04f37d5111280fe5bd63a35cf4b8232d609adb8fe21e0e87a9a6f90497264f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b94285b6f18e341a94173c5113f44a460f6caf432850141dfedbb46a446b7bd0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a17df59e81a6f83cfae29c9892266b656ed8c6e2bf36e6e71fbbaf2dd1d97d73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d58f00e8e1a1e2b3c1f7b452a0614e0946977106bc5589f56d5c32179860168"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"clx", ldflags: "-s -w"), "./cmd/clx"
    man1.install "share/man/clx.1"
    bash_completion.install "share/completions/clx.bash" => "clx"
    zsh_completion.install  "share/completions/_clx"     => "_clx"
    fish_completion.install "share/completions/clx.fish"
  end

  test do
    ENV["XDG_CONFIG_HOME"] = testpath/".config"
    config_home = testpath/".config"

    assert_match "Item added to favorites", shell_output("#{bin}/clx add 1")
    assert_path_exists config_home/"circumflex/favorites.json"
  end
end