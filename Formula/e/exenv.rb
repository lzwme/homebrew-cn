class Exenv < Formula
  desc "Elixir versions management tool"
  homepage "https:github.commururuexenv"
  url "https:github.commururuexenvarchiverefstagsv0.1.0.tar.gz"
  sha256 "368095760ecc386a0930954f5f0ce7cea977641fe6d27b1beff032f512598a58"
  license "MIT"
  head "https:github.commururuexenv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ae3d33c35709202895d8d27bff0ea95075cd1455cc20207b139c43b73ca34322"
  end

  disable! date: "2023-06-19", because: :repo_archived

  def install
    inreplace "libexecexenv", "usrlocal", HOMEBREW_PREFIX
    prefix.install Dir["*"]
  end

  test do
    system "#{bin}exenv", "init", "-"
  end
end