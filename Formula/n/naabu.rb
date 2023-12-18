class Naabu < Formula
  desc "Fast port scanner"
  homepage "https:github.comprojectdiscoverynaabu"
  url "https:github.comprojectdiscoverynaabuarchiverefstagsv2.2.0.tar.gz"
  sha256 "a110908ff162413056f36c49b27afedf730a732fca7b1ba06db8652d682baaba"
  license "MIT"
  head "https:github.comprojectdiscoverynaabu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7fe866b43a8960c10cb0171736a7031dfa2d5a8a317014b0614a67f0b9d313b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80b90e0c7f8b0d7e8d433921456e4e567d883b2d0670516afbf930d79a76bb1c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55e75d3fbf4893a969ecf009975630a31e6b2b86077178b4aeaa52fba34f8bf0"
    sha256 cellar: :any_skip_relocation, sonoma:         "9388b3f712e60e2dff8d311fc21765b739571d23bd7c25be917b5778d145d734"
    sha256 cellar: :any_skip_relocation, ventura:        "ad1dda77f24c4c21b5898cf5f9761897aa0d9f5684ee7985873548ad2ebd2dda"
    sha256 cellar: :any_skip_relocation, monterey:       "e1e78d77d7a01cd04bde8112204ccdc90d2793e64fd5d6ed755b1afaa0df33f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea5d8b50ad98b6d453a93213e6c4bf615d5d6e2a30c6a8bea25d445f95776efe"
  end

  depends_on "go" => :build

  uses_from_macos "libpcap"

  def install
    cd "v2" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdnaabu"
    end
  end

  test do
    assert_match "brew.sh:443", shell_output("#{bin}naabu -host brew.sh -p 443")
  end
end