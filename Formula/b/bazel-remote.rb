class BazelRemote < Formula
  desc "Remote cache for Bazel"
  homepage "https://github.com/buchgr/bazel-remote/"
  url "https://ghfast.top/https://github.com/buchgr/bazel-remote/archive/refs/tags/v2.6.3.tar.gz"
  sha256 "8f0cf412224a75c22c1770dcd0bfe0d8fc597d9ea0ae21a8c01da3c162037e83"
  license "Apache-2.0"
  head "https://github.com/buchgr/bazel-remote.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f01c15a2fc85108a84204c7fb381356317bff06f95f587b03772ff8904189ed8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b96d6ad5bde328dd4c8bae6f3cfcc73790fa3901bcf4efda577f612dbc02d881"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d5820906543ef67fd5b1932f6fcd70b568d433224bc2c68cf08fbb6d27c39821"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d4f6bc5528db63f41fd8402fa8dd48917eb100dca6a404269bab710fb6286218"
    sha256 cellar: :any,                 x86_64_linux:      "d80caba59050f0a485183d56074689150745488fbb501a7f1441a6527c1c8ec3"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.gitCommit=#{version}")
  end

  test do
    ENV["BAZEL_REMOTE_DIR"] = "test"
    ENV["BAZEL_REMOTE_MAX_SIZE"] = "10"

    begin
      pid = spawn bin/"bazel-remote"
      sleep 2
      assert_path_exists testpath/"test", "Failed to create test directory"
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end