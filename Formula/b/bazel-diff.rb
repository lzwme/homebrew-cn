class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://ghfast.top/https://github.com/Tinder/bazel-diff/archive/refs/tags/v32.0.0.tar.gz"
  sha256 "f7c7c99d9ee0109c8a6edbb73d8f3cb843f17e86e5abc3a1bb02689eff6a0185"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fcf52b89c20c21dd009a5af0c1f14f18519c5fd5266b01b63474f92da3e7d653"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fcf52b89c20c21dd009a5af0c1f14f18519c5fd5266b01b63474f92da3e7d653"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fcf52b89c20c21dd009a5af0c1f14f18519c5fd5266b01b63474f92da3e7d653"
    sha256 cellar: :any_skip_relocation, sonoma:        "fcf52b89c20c21dd009a5af0c1f14f18519c5fd5266b01b63474f92da3e7d653"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1883b45c7f960aa9f19d48e2574bf18238c481961935ca1a8bcd852e53d4ff4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1883b45c7f960aa9f19d48e2574bf18238c481961935ca1a8bcd852e53d4ff4"
  end

  depends_on "bazel" => [:build, :test]
  depends_on "openjdk"

  def install
    ENV["JAVA_HOME"] = formula_opt_prefix("openjdk")
    rm ".bazelversion"

    extra_bazel_args = %w[
      -c opt
      --@protobuf//bazel/toolchains:prefer_prebuilt_protoc
      --enable_bzlmod
      --java_runtime_version=local_jdk
      --tool_java_runtime_version=local_jdk
      --repo_contents_cache=
    ]

    system "bazel", "build", *extra_bazel_args, "//cli:bazel-diff_deploy.jar"

    libexec.install "bazel-bin/cli/bazel-diff_deploy.jar"
    bin.write_jar_script libexec/"bazel-diff_deploy.jar", "bazel-diff"
  end

  test do
    output = shell_output("#{bin}/bazel-diff generate-hashes --workspacePath=#{testpath} 2>&1", 1)
    assert_match "ERROR: The 'info' command is only supported from within a workspace", output
  end
end