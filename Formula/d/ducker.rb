class Ducker < Formula
  desc "Slightly quackers Docker TUI based on k9s"
  homepage "https:github.comrobertpsoaneducker"
  url "https:github.comrobertpsoaneduckerarchiverefstagsv0.2.2.tar.gz"
  sha256 "23ab9c9588c65a7d650cdfcb73b3e3659d5943352599150445b3270b8a3b3241"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5e2a9191af9591ef67e028e2b853abd7e4f4bcf51b3af595a92a55d43d271a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb2c96bd228b06dd54a25f3ca6dc7ad060407698f3c291ad1fedd646fec14802"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "146d7df97c022e370343739b2adf0ea4bb31070f1d1df49f591cb4681708e8e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f173836689825a5c14fcb93f79e0bc79505d2cb0ff797859f24e459a40e651c"
    sha256 cellar: :any_skip_relocation, ventura:       "16e5e23ad5c97f35e9e9f78b5aa84da46d77f738174e6f97a6cc42908a3e812a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe7b35e45c3c8da92ab94c4d5f6a9d0e77bae47b07575b1f9c7dd5b673a4fb2c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}ducker --export-default-config 2>&1", 1)
    assert_match "failed to create docker connection", output

    assert_match "ducker #{version}", shell_output("#{bin}ducker --version")
  end
end