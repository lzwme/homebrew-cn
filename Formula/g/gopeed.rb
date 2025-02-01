class Gopeed < Formula
  desc "Modern download manager that supports all platform"
  homepage "https:gopeed.com"
  url "https:github.comGopeedLabgopeedarchiverefstagsv1.6.8.tar.gz"
  sha256 "7f5eaf4e63bbbf48c22b573c10ae306e3dfac6b267f48b8af396f362738cab39"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d4de803d823a6fd313a5a88e3433ea34db519224b48b84bedd3c581891f58a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f87301495f7a4864c104a0f40adbea03d6675f43806e178c87d2d3cc6da92b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "baaaed5079c9ee43c7dff7f045f1b325236c466f8af3d472d9526d18a7e6dac3"
    sha256 cellar: :any_skip_relocation, sonoma:        "fda34fa3a8b40dde73c77a4e85fe05866ae5cb1185e76bdff8569fe0d19a00ab"
    sha256 cellar: :any_skip_relocation, ventura:       "8a604c23ed94d0666086a56037be6bb6b56be76f8bdd48e93d230e341f632ce9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca2024d4744c1b830d6884a72aa806c6bc96a52026345aac7c70f139f20df452"
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