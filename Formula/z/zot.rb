class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.45.tar.gz"
  sha256 "e2906caea8ef196e292e880d7680b6c39f0ba594f1ca65654ace7a2c692dec57"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0d48997abeccb11946b88882220d3ab1c9ad50ac573bcd670fa8ba44bae1125"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0d48997abeccb11946b88882220d3ab1c9ad50ac573bcd670fa8ba44bae1125"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0d48997abeccb11946b88882220d3ab1c9ad50ac573bcd670fa8ba44bae1125"
    sha256 cellar: :any_skip_relocation, sonoma:        "5fede9532d381b1ba4732d4ab5f23a4c3d9e5c122f61a87292bfa09ff25898fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44c9b4278d1c4e4f14b2a8e96a7a2c1a09b2197254ef093f168aaba39face72b"
    sha256 cellar: :any,                 x86_64_linux:  "5794bb50ec0eab26b7dd637dcfed54833ad406a2d9582a59db276998453ec5f2"
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