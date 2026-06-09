class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.20.16",
      revision: "ed8903300aeb9e17b8556c31a15334007efbcb96"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "14506c87aa9138a9cec5dca8097965857d9e1856d8cba335a262649c3a6d465a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4fd71532ddc79d82bb5008550a343034e01efe1fae404bb5aa0e6e45ffb92f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0e2ff88019b527977a3b8bd76b89d878c3b6b7a18a64db43fb5cef9f1429483"
    sha256 cellar: :any_skip_relocation, sonoma:        "2441174557980e185077a9f42ded7b78a08b6bee7f2a9c85833440906a307fe9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b30a5a149b54d4dea9c7fca0aa6ea185843847599c1613a536d1d5191d2d061"
    sha256 cellar: :any,                 x86_64_linux:  "59a59a790271489f0247a4347b051a3ce2d80d57ac127a6466a52af258ffdab2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/yoke"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yoke version")

    assert_match "failed to build k8 config", shell_output("#{bin}/yoke inspect 2>&1", 1)
  end
end