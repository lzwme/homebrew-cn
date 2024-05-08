class Chainhook < Formula
  desc "Reorg-aware indexing engine for the Stacks & Bitcoin blockchains"
  homepage "https:github.comhirosystemschainhook"
  url "https:github.comhirosystemschainhookarchiverefstagsv1.5.1.tar.gz"
  sha256 "ccea19c9e81672ddb58cfda84cdd5d923cc26af422c2c1b81d9424125d85ba2d"
  license "GPL-3.0-only"
  head "https:github.comhirosystemschainhook.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7f551cacdd63479948f8b36fa48cae52b96680546e2b5e87d8e0349376ec71c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c31c59a5db5007c71d6394e9ded740a8d0bda28612f4c2cfb585254204ab4a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "210ac9359833c4b141918f812fe445422a93ddb076f0d7c41740e86136b83ff3"
    sha256 cellar: :any_skip_relocation, sonoma:         "8b4be0c1b6d63e79957abf7a080a81ff187fbba804c5fe61efb5370f227744b3"
    sha256 cellar: :any_skip_relocation, ventura:        "ba645f597535377f1212acc2df5d4b70294997a1d7ac4908c4a374ba755ca466"
    sha256 cellar: :any_skip_relocation, monterey:       "2689119ac8dd1834df7d10606b584e9978f9d5e782370b413e43ac4110481fbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47d46aba554d3395726b42c183e0d4e7bdee45352a2b9473a9395eb81b925fd0"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang

  def install
    system "cargo", "install", "--features", "cli,debug", "--no-default-features",
                                *std_cargo_args(path: "componentschainhook-cli")
  end

  test do
    pipe_output("#{bin}chainhook config new --mainnet", "n\n")
    assert_match "mode = \"mainnet\"", (testpath"Chainhook.toml").read
  end
end