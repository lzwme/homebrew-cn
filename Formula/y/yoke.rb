class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.20.5",
      revision: "4434f07f4d75316a54fd469baaf740d48f50af5e"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ccb2215ffda72e66a63972a83b947177bf0dc71cc1ab2a2cb7f39b6fb8c976e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8225649de8fbc9ff48cee40d1ad51a2ea7a2ca872a4de29d342271ddc404afa0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ccc3ad41d7790b50d2c308a3f29a3d3c9c9f5f492465cc8d8bc274eb17e9ce3"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4cca7a02830ddee1a896caf0093d23f983d35e2f86c39936948423a3ffa8da5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b640f1c5a5fb9a5f3f428410362604afab2e5aaf59a530e30b421fbbaf50fa39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e244ef898138565417a0e80634d5b4e66618551c349740ee0357d86a9ff3062f"
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