class Difi < Formula
  desc "Pixel-perfect terminal diff viewer"
  homepage "https://github.com/xguot/difi"
  url "https://ghfast.top/https://github.com/xguot/difi/archive/refs/tags/v0.2.11.tar.gz"
  sha256 "d0d598e9b13ca0dc9dd93d78a13500c322c6f1e35713dbbba070155f6c1ee393"
  license "MIT"
  head "https://github.com/xguot/difi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2037233ea86f6149abdf24dc8224a9a5f74a965cfeff1057536d343d7aac4c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2037233ea86f6149abdf24dc8224a9a5f74a965cfeff1057536d343d7aac4c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2037233ea86f6149abdf24dc8224a9a5f74a965cfeff1057536d343d7aac4c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f9c1cc46ab2184cc6e43fcc203ea42afa3131bc5b378bc82096877a46f0b4a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9ea8a98525d87155f706afc60f2ca7640a0feea2f9fb42803399da82127476e"
    sha256 cellar: :any,                 x86_64_linux:  "1c005445c9117d2a965e8da833f5cd7ca70aff4141bb3785ef9589cc58dded87"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/difi"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/difi -version")

    system "git", "init"
    system "git", "config", "user.email", "test@example.com"
    system "git", "config", "user.name", "Test"

    (testpath/"file.txt").write("one")
    system "git", "add", "file.txt"
    system "git", "commit", "-m", "init"

    File.write(testpath/"file.txt", "two")
    system "git", "commit", "-am", "change"

    output = shell_output("#{bin}/difi --plain HEAD~1")
    assert_match "file.txt", output
  end
end