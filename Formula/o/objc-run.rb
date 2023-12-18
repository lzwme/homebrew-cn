class ObjcRun < Formula
  desc "Use Objective-C files for shell script-like tasks"
  homepage "https:github.comiljaiwasobjc-run"
  url "https:github.comiljaiwasobjc-runarchiverefstags1.4.tar.gz"
  sha256 "6d02a31764c457c4a6a9f5df0963d733d611ba873fc32672151ee02a05acd6f2"
  license "MIT"
  head "https:github.comiljaiwasobjc-run.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "951d50ad3ee4ebb9d0717b4df365870b44626195378b9d5c64bcf7b320e8cc14"
  end

  def install
    bin.install "objc-run"
    pkgshare.install "examples", "test.bash"
  end

  test do
    cp_r pkgshare, testpath
    system ".objc-runtest.bash"
  end
end