class Goawk < Formula
  desc "POSIX-compliant AWK interpreter written in Go"
  homepage "https://benhoyt.com/writings/goawk/"
  url "https://ghproxy.com/https://github.com/benhoyt/goawk/archive/refs/tags/v1.23.1.tar.gz"
  sha256 "f6060f11d25942bd28e49e08aee09025be442788604cb645a9e161ed394b2509"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "252a7821dabf4d4275d073a4b8b034dd18e9ee30d2efba825c29207120a523a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "252a7821dabf4d4275d073a4b8b034dd18e9ee30d2efba825c29207120a523a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "252a7821dabf4d4275d073a4b8b034dd18e9ee30d2efba825c29207120a523a1"
    sha256 cellar: :any_skip_relocation, ventura:        "655857e88f7869cfb643424b76acdd2816246f220325c8137e3ffefdc1e378a1"
    sha256 cellar: :any_skip_relocation, monterey:       "655857e88f7869cfb643424b76acdd2816246f220325c8137e3ffefdc1e378a1"
    sha256 cellar: :any_skip_relocation, big_sur:        "655857e88f7869cfb643424b76acdd2816246f220325c8137e3ffefdc1e378a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfedb425c31122d1b5b07d178098818e5bc780afc42436647328290b5beb8c96"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = pipe_output("#{bin}/goawk '{ gsub(/Macro/, \"Home\"); print }' -", "Macrobrew")
    assert_equal "Homebrew", output.strip
  end
end