class Viddy < Formula
  desc "Modern watch command"
  homepage "https:github.comsachaosviddy"
  url "https:github.comsachaosviddyarchiverefstagsv1.2.1.tar.gz"
  sha256 "e8ccd83b312078e3f32d6c154d607a1efe4f9e030b5f0a5d375d7e57c2706836"
  license "MIT"
  head "https:github.comsachaosviddy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45af9d11315d041fc598c0f8e1c2ffe9fd90d13427dee0fa57e403638951dcce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8091e98a7dd08d8b26e487855396717f7ff991dd8971fae50a4d936e06dc1a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "47f1a2f8bec86ef115e2a29ef112c598613e68f33e52c963024f1f96325a16fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d94c26de4bc8f40dd40511c2bf368d2687e844549aca1bdb5e88226de214c55"
    sha256 cellar: :any_skip_relocation, ventura:       "719c8e8e0ae3ea5ac884851861f8f517365fb8b20216b2c0d117ef66539a0c71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab52e0bd1014877a0f8939d82d6c3c0bf8517f79e49cf50eb9eb4871906ba23d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Errno::EIO: Inputoutput error @ io_fread - devpts0
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      pid = fork do
        system bin"viddy", "--interval", "1", "date"
      end
      sleep 2
    ensure
      Process.kill("TERM", pid)
    end

    assert_match "viddy #{version}", shell_output("#{bin}viddy --version")
  end
end