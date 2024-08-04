class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https:github.comprojectdiscoveryhttpx"
  url "https:github.comprojectdiscoveryhttpxarchiverefstagsv1.6.7.tar.gz"
  sha256 "a637d083eb09e2b1ed3c13843b95cbac0f566ce72f5fbc55a67965570d5e0582"
  license "MIT"
  head "https:github.comprojectdiscoveryhttpx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "394a97dfac7b47835d158f4a61f3560bfec18d0c2aa7b4d0001a955660ef75c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7deef9ba794b4f4f3cd6d3b23632a82eea940f184f0433acb97403dbe6d62c7a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d188739ebdf8e693d0a20937ec1e85ee0e9357e873a5e942303c31564e89557"
    sha256 cellar: :any_skip_relocation, sonoma:         "6c37753cfc0517dfec3ba95e11895035414befbd978270a08d5a5a1f1863f428"
    sha256 cellar: :any_skip_relocation, ventura:        "fdb801fddda6abdc977d6c3ec6225f6e9c1d8b5d759ce203926a231cbbca371e"
    sha256 cellar: :any_skip_relocation, monterey:       "0cf6373db719c297d774d1131a336964c6d9095a80b6ca6699debac17918191b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8063c9be8cd371b8ef0f8744f276b8bb3e9213b04fe0803e925ddfba667012c6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdhttpx"
  end

  test do
    output = JSON.parse(shell_output("#{bin}httpx -silent -title -json -u example.org"))
    assert_equal 200, output["status_code"]
    assert_equal "Example Domain", output["title"]
  end
end