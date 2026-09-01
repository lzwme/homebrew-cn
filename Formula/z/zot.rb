class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.54.tar.gz"
  sha256 "561ee1dd62022f3f4c777a19abb5c54ad1f728055a7b049363703daeb135a0fb"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a42ff6198ceef4224c58dff5dc6f45b6993366a6cb8e93269d48fccb97dc7348"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a42ff6198ceef4224c58dff5dc6f45b6993366a6cb8e93269d48fccb97dc7348"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a42ff6198ceef4224c58dff5dc6f45b6993366a6cb8e93269d48fccb97dc7348"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84d4904224482ee2ed4c4f29a320b273ba827b9c4cbe7c578e61727abcb7086e"
    sha256 cellar: :any,                 x86_64_linux:  "140f056abb6d598142016c1a940c113129a3a3822c54e630095922285e5d3d91"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/zot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zot --version")
    assert_match "zot: no credential for anthropic", shell_output("#{bin}/zot rpc 2>&1", 1)
  end
end