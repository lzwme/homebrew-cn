class Ratchet < Formula
  desc "Tool for securing CICD workflows with version pinning"
  homepage "https:github.comsethvargoratchet"
  url "https:github.comsethvargoratchetarchiverefstagsv0.9.0.tar.gz"
  sha256 "e6d418075866a0c1040ef36a009cb4f8d2ed0edf6f4b5cb0041c3d076c6a349a"
  license "Apache-2.0"
  head "https:github.comsethvargoratchet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e39242b556f7dd32c0787cd4ac202b6efd7c9f79b2fb668256b9bc70180a71d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5ebe41bb45009ee06a96708f96c6839cdbce73d973464982327428f83839cef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f32af900b47f7211aca5839a5599fc6b809e820c8b2a41b908146baf5af9ddac"
    sha256 cellar: :any_skip_relocation, sonoma:         "971e55b30e310c7909a9a58ab8824a2e1da8c0ee3951bba514e86adba425d1f8"
    sha256 cellar: :any_skip_relocation, ventura:        "c57001f00986ffee5daa2f59845432a448dc89b68331716fd6ab735c80883951"
    sha256 cellar: :any_skip_relocation, monterey:       "f9e36d5c657d3c467eb22a0cbe864ecbd42e9dcd30e91ce0abcb442a2f8dfc70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ca58e353ee0b84c70768fcfefd11b11e816fac59ac369dc243daec4b2133fa4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    pkgshare.install "testdata"
  end

  test do
    cp_r pkgshare"testdata", testpath
    output = shell_output(bin"ratchet check testdatagithub.yml 2>&1", 1)
    assert_match "found 4 unpinned refs", output
  end
end