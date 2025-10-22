class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://ghfast.top/https://github.com/Tinder/bazel-diff/releases/download/12.0.0/bazel-diff_deploy.jar"
  sha256 "4371973e576aaa9fbff81a111b082819f49ce169962520472d19db03c2889830"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "377dd08298b91d08bab39211cf95c842250078bfe78d583329b9c7333ba00a5c"
  end

  depends_on "bazel" => :test
  depends_on "openjdk"

  def install
    libexec.install "bazel-diff_deploy.jar"
    bin.write_jar_script libexec/"bazel-diff_deploy.jar", "bazel-diff"
  end

  test do
    output = shell_output("#{bin}/bazel-diff generate-hashes --workspacePath=#{testpath} 2>&1", 1)
    assert_match "ERROR: The 'info' command is only supported from within a workspace", output
  end
end