class Dish < Formula
  desc "Lightweight monitoring service that efficiently checks socket connections"
  homepage "https:github.comthevxndish"
  url "https:github.comthevxndisharchiverefstagsv1.11.4.tar.gz"
  sha256 "c9e1c8d531c0acc6da4bd15ac28f5ea9a727430a49442c229acbcea86144e197"
  license "MIT"
  head "https:github.comthevxndish.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c5d2d8e4d0e983d035df7502050de5ffad850c7556d1bb739e158bc83557968"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c5d2d8e4d0e983d035df7502050de5ffad850c7556d1bb739e158bc83557968"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0c5d2d8e4d0e983d035df7502050de5ffad850c7556d1bb739e158bc83557968"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f8f0cdd6265fac3cc639ae66c8ee83f4d8ed8cb77b27251abeac8b885a1558d"
    sha256 cellar: :any_skip_relocation, ventura:       "1f8f0cdd6265fac3cc639ae66c8ee83f4d8ed8cb77b27251abeac8b885a1558d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c517c253a00e9aa615a3a6663efe825b431d55f74e2e00cf0da360d91eece52c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmddish"
  end

  test do
    ouput = shell_output("#{bin}dish https:example.com:instance 2>&1", 3)
    assert_match "error loading socket list: failed to fetch sockets from remote source", ouput
  end
end