class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https:murex.rocks"
  url "https:github.comlmorgmurexarchiverefstagsv6.4.0375.tar.gz"
  sha256 "8684c3b21cbc3d37828cc20d85dda32a69d5117909e7e0fe434596517972a182"
  license "GPL-2.0-only"
  head "https:github.comlmorgmurex.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80d3c0ba2ba94d6e144c4e75aa82971b84d19923ea2e5bb9cd27e2bf8e80a906"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80d3c0ba2ba94d6e144c4e75aa82971b84d19923ea2e5bb9cd27e2bf8e80a906"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "80d3c0ba2ba94d6e144c4e75aa82971b84d19923ea2e5bb9cd27e2bf8e80a906"
    sha256 cellar: :any_skip_relocation, sonoma:        "119a92544888f18a44b2591cd4f88171939ca6c80b2126720b23759dfc8dfb09"
    sha256 cellar: :any_skip_relocation, ventura:       "119a92544888f18a44b2591cd4f88171939ca6c80b2126720b23759dfc8dfb09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32c1f750fe1349eff4242817784496b6d108982e731b63d9986a018df2837300"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_equal "homebrew", shell_output("#{bin}murex -c 'echo homebrew'").chomp
    assert_match version.to_s, shell_output("#{bin}murex -version")
  end
end