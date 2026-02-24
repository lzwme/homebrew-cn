class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://ghfast.top/https://github.com/TomWright/dasel/archive/refs/tags/v3.2.3.tar.gz"
  sha256 "45351c07993e6c472eaa1231f30b61e927b1295f34063e4228d8dd7ff75ce538"
  license "MIT"
  head "https://github.com/TomWright/dasel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92aab81b7b49e3a4d2944dcf53a8afde39e8eb8e31b206f899604fcaeb9d623b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92aab81b7b49e3a4d2944dcf53a8afde39e8eb8e31b206f899604fcaeb9d623b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92aab81b7b49e3a4d2944dcf53a8afde39e8eb8e31b206f899604fcaeb9d623b"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8b35975601d9ea19703f88fe765ebc85f17a00b414594b59c2ab1b943b88da5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a1d262d7df45d25e3e5dfda29d632791a4bcefb51605eb9039aa46466e3c300"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8157f812e5689e469c5bf46575b1b83f3dfda840e8faedf88af5ab186d19bff"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/tomwright/dasel/v#{version.major}/internal.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/dasel"
  end

  test do
    assert_equal "\"Tom\"", pipe_output("#{bin}/dasel -i json 'name'", '{"name": "Tom"}', 0).chomp
    assert_match version.to_s, shell_output("#{bin}/dasel version")
  end
end