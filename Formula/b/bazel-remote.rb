class BazelRemote < Formula
  desc "Remote cache for Bazel"
  homepage "https://github.com/buchgr/bazel-remote/"
  url "https://ghfast.top/https://github.com/buchgr/bazel-remote/archive/refs/tags/v2.5.2.tar.gz"
  sha256 "aaa712137a785e29bb30aa187b21bdc10d99e590e17e31cf2298cc89a73e45f5"
  license "Apache-2.0"
  head "https://github.com/buchgr/bazel-remote.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ab0211b47f608283cc52aa791aafbb74dbb15e3d8f9c2926e07664400bf8f6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "edbed5b8b43cb68c926f609a85a92161bbd8a555c211aecf41b3018c37fa2110"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "92011df78f667e5f345aa6e3da7e2d4755d582f6b53fcde48737df099535b540"
    sha256 cellar: :any_skip_relocation, sonoma:        "9dadb8e02058493e236e3ceb89fad7ef675866165abc39da27e8d14f9f5ac10d"
    sha256 cellar: :any_skip_relocation, ventura:       "acc4af9ba79d8a77ae164f4ee1baa570c7c3b055b3c260247f72e3e2b9d91911"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80c237a27cbb694ac169ae269a87ec222c0dfdceb4296ab16b08821073b8abae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c887564c6d3ebb6f2eb70af4fd5589b10fb2ff48781d534ee47f632d0c3cedfa"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.gitCommit=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    ENV["BAZEL_REMOTE_DIR"] = "test"
    ENV["BAZEL_REMOTE_MAX_SIZE"] = "10"

    begin
      pid = fork { exec bin/"bazel-remote" }
      sleep 2
      assert_path_exists testpath/"test", "Failed to create test directory"
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end