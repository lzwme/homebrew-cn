class Mark < Formula
  desc "Sync your markdown files with Confluence pages"
  homepage "https://samizdat.dev"
  url "https://ghfast.top/https://github.com/kovetskiy/mark/archive/refs/tags/v16.19.0.tar.gz"
  sha256 "2fc172fe466510778437de38b94385226089f8a44243913a63b578bb382c163b"
  license "Apache-2.0"
  head "https://github.com/kovetskiy/mark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ca320e473618f5de7aa0be3d671e77241d4fb4d02f39a6d51f7972fdce97e26"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ca320e473618f5de7aa0be3d671e77241d4fb4d02f39a6d51f7972fdce97e26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ca320e473618f5de7aa0be3d671e77241d4fb4d02f39a6d51f7972fdce97e26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8641b51475e7bf45d916cddcf79c4a03a810a6ced21659e718a16039845f38f"
    sha256 cellar: :any,                 x86_64_linux:  "85cacfcfacbda3833c1d91ea29c3bca86019e62072e98b93c20213733d101811"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
    assert_match "confluence base URL should be specified", output
  end
end