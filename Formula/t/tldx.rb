class Tldx < Formula
  desc "Domain Availability Research Tool"
  homepage "https:brandonyoung.devblogintroducing-tldx"
  url "https:github.combrandonyoungdevtldxarchiverefstagsv1.2.2.tar.gz"
  sha256 "10de9a5d1d65f29d639abeb030c15eeb7cc23784dc00d3c68f8aa397c299ca3a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5553a1609d195f6eabe75a820f9cf02483336195ccc346e6ba75bbd92d274d8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5553a1609d195f6eabe75a820f9cf02483336195ccc346e6ba75bbd92d274d8e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5553a1609d195f6eabe75a820f9cf02483336195ccc346e6ba75bbd92d274d8e"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a183088e8cf7daa5c4b210ec247ed7d02752e9117f53b2353c65752cf9a9431"
    sha256 cellar: :any_skip_relocation, ventura:       "6a183088e8cf7daa5c4b210ec247ed7d02752e9117f53b2353c65752cf9a9431"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cee881a4c02bdbf0d35eada5e441fe12871447d63f260163bbdd08e53a5283f1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "brew.sh is not available", shell_output("#{bin}tldx brew --tlds sh")
  end
end