class Gopeed < Formula
  desc "Modern download manager that supports all platform"
  homepage "https:gopeed.com"
  url "https:github.comGopeedLabgopeedarchiverefstagsv1.6.10.tar.gz"
  sha256 "79a5e1eb7efc5532ebe71071723fb61b40fdcfba8585731dbc1b87f701192fba"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9de7301f62a24610a278167564febb319afe3a38f4d9cc0115f3790053687ead"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "768951854baad2d572b93618bee6231b8c430af3b3c64ae6310b0e8317cf065a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fea037ae41665885f8d5f74dae0f7d9a07cbcea283aea291c8be8c119b8f3987"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5853c6a2f32e1e76c083616248bbb2d0754d2b4fd0fee598f939f4ef7da6f3d"
    sha256 cellar: :any_skip_relocation, ventura:       "7dd1eb6b425190eb37aaed6d100092e0ab767a8334adda42a9c8f241118db65a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a91281af021417e91cc74a723e7e30e5b6b769316aa65d8c5263b6f8ac0b0cea"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdgopeed"
  end

  test do
    output = shell_output("#{bin}gopeed https:example.com")
    assert_match "saving path: #{testpath}", output
    assert_match "Example Domain", (testpath"example.com").read
  end
end