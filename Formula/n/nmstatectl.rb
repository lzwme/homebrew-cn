class Nmstatectl < Formula
  desc "Command-line tool that manages host networking settings in a declarative manner"
  homepage "https://nmstate.io/"
  url "https://ghfast.top/https://github.com/nmstate/nmstate/releases/download/v2.2.50/nmstate-2.2.50.tar.gz"
  sha256 "929c2ea4a259ab6e659655be3eaa698047375fe9e461169ae1af57be7b26576d"
  license "Apache-2.0"
  head "https://github.com/nmstate/nmstate.git", branch: "base"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f6b65c7a255875b8eb74f02da3264409503f073b2673bfbb9260c3abae58b7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03b57a5368b58d319606b0cd162937fc5d42acd2464449ad81d25f6e3e1469c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3041679aceeb38fad3ed04ec5ceaa79073abf80c05bea71fc061fb07184ae8de"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a2239fe9bd2c59ed7ee97c787868a7e75177a6f9532663b2c0bdcf510ce82fd"
    sha256 cellar: :any_skip_relocation, ventura:       "4ea8a1ff7837557113909ba1d382f52a2238618d83490355c320228abf4b64d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e05fd61f8590dc17d75632c030e045a983ed8bd0543a5c0e2e43686b44718521"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05bace17549be21d37d581043a9e3924c0b103f00149871aa4782bac4161a21a"
  end

  depends_on "rust" => :build

  def install
    cd "rust" do
      args = if OS.mac?
        ["--no-default-features", "--features", "gen_conf"]
      else
        []
      end
      system "cargo", "install", *args, *std_cargo_args(path: "src/cli")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nmstatectl --version")

    assert_match "interfaces: []", pipe_output("#{bin}/nmstatectl format", "{}", 0)
  end
end