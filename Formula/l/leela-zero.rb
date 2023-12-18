class LeelaZero < Formula
  desc "Neural Network Go engine with no human-provided knowledge"
  homepage "https:zero.sjeng.org"
  # pull from git tag to get submodules
  url "https:github.comleela-zeroleela-zero.git",
      tag:      "v0.17",
      revision: "3f297889563bcbec671982c655996ccff63fa253"
  license "GPL-3.0-or-later"
  revision 5

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d93abf4cb2757bb14d2928fec5b20bc59941e06ad1868cc8cdf2ef0ad6eadefe"
    sha256 cellar: :any,                 arm64_ventura:  "c455894993c09adadcbb9cc4a66c2970a92f93ada6d84222229abb88f32021b7"
    sha256 cellar: :any,                 arm64_monterey: "fdf249e8db820b74ddaf91c67b5e33ce4750018e6cc800bc992767ca6ed770be"
    sha256 cellar: :any,                 sonoma:         "cd4dd646da4db0f6bca6afbf354227338b1f587ca9c6819f492e78ef86148376"
    sha256 cellar: :any,                 ventura:        "7fd7cf4d42962a2295ed80ef78ef32a3eaeab780f7380c2baee93c3989105ad0"
    sha256 cellar: :any,                 monterey:       "f612c6accdaa4f51400e69f30491e83432ed2aeccce5b57fde7d04d2b5f2e458"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4555abb468d6a04c55dae0916929c494b7f371e7dbe74394be7e830dc882ee05"
  end

  depends_on "cmake" => :build
  depends_on "boost"

  on_linux do
    depends_on "opencl-headers" => :build
    depends_on "opencl-icd-loader"
    depends_on "pocl"
  end

  resource "network" do
    url "https:zero.sjeng.orgnetworks00ff08ebcdc92a2554aaae815fbf5d91e8d76b9edfe82c9999427806e30eae77.gz", using: :nounzip
    sha256 "5302f23818c23e1961dff986ba00f5df5c58dc9c780ed74173402d58fdb6349c"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install resource("network")
  end

  test do
    system bin"leelaz", "--help"
    assert_match(^= [A-T][0-9]+$,
      pipe_output("#{bin}leelaz --cpu-only --gtp -w #{pkgshare}*.gz", "genmove b\n", 0))
  end
end