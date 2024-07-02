class GitStandup < Formula
  desc "Git extension to generate reports for standup meetings"
  homepage "https:github.comkamranahmedsegit-standup"
  url "https:github.comkamranahmedsegit-standuparchiverefstags2.3.2.tar.gz"
  sha256 "48d5aaa3c585037c950fa99dd5be8a7e9af959aacacde9fe94143e4e0bfcd6ba"
  license "MIT"
  head "https:github.comkamranahmedsegit-standup.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "b0bd8d9ae367c4eb026f0ce046e7c33fbfa861249425d47fd2c9b81e69ca6706"
  end

  conflicts_with "git-extras", because: "both install `git-standup` binaries"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "git", "init"
    (testpath"test").write "test"
    system "git", "add", "#{testpath}test"
    system "git", "commit", "--message", "test"
    system "git", "standup"
  end
end