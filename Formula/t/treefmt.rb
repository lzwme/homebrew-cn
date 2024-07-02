class Treefmt < Formula
  desc "One CLI to format the code tree"
  homepage "https:github.comnumtidetreefmt"
  url "https:github.comnumtidetreefmtarchiverefstagsv2.0.2.tar.gz"
  sha256 "513afebec7dd563d78a5e8fc6e5316610ad78419fea2121d4b080bae0f1ae647"
  license "MIT"
  head "https:github.comnumtidetreefmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "258c2ed7c70c78a300dc4062a2999624bbce38f6df851b07f1705941e873f1f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b608b96dc93e3d58af43811433972cea7becc431d85cf0f4a034d6a085e7695"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5282b9f74ffdbc8041201180e50af8d7b2781aae9ad2469a26ecd4e06ec54e53"
    sha256 cellar: :any_skip_relocation, sonoma:         "903c939dcdf890f7b0f80421e9a099fd667f269f3bf32414ddd903db95b6d0dc"
    sha256 cellar: :any_skip_relocation, ventura:        "24e65d57ac85527fe6064e850adf5f2e11da7beda844829e5e26d07a31a86e78"
    sha256 cellar: :any_skip_relocation, monterey:       "b54e58da6be46c2b4f49b1051794bc2510a507a001392e67ff78bd27dbdc7380"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc65544ea3786311707b62ea6fe06d636e444f5dc20a78ffc287b6fed18551fd"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X git.numtide.comnumtidetreefmtbuild.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match "error: could not find treefmt.toml", shell_output("#{bin}treefmt 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}treefmt --version")
  end
end