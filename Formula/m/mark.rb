class Mark < Formula
  desc "Sync your markdown files with Confluence pages"
  homepage "https://samizdat.dev"
  url "https://ghfast.top/https://github.com/kovetskiy/mark/archive/refs/tags/v16.15.0.tar.gz"
  sha256 "d81159680527bccbb2c2fba0a99e4b137dcaf7321f1c2ed2ce9fac82832d2c78"
  license "Apache-2.0"
  head "https://github.com/kovetskiy/mark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "432e1d1203066a1a6f8430d2407d65ad067346badf109f6d080a70503296fe93"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "432e1d1203066a1a6f8430d2407d65ad067346badf109f6d080a70503296fe93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "432e1d1203066a1a6f8430d2407d65ad067346badf109f6d080a70503296fe93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ae1b75e8b8376819e9bf4446ecb9b98588d4e2b5601f9cf4c6db1273d99822e"
    sha256 cellar: :any,                 x86_64_linux:  "73d5b1f0661a9af23a9ba6745b9f7a5327b52f11a2bdee8897eb5590a78956da"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/mark"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mark --version")

    (testpath/"test.md").write <<~MARKDOWN
      # Hello Homebrew
    MARKDOWN

    touch testpath/"mark.toml"
    output = shell_output("#{bin}/mark --config mark.toml sync 2>&1", 1)
    assert_match "confluence password should be specified", output
  end
end