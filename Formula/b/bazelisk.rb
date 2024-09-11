class Bazelisk < Formula
  desc "User-friendly launcher for Bazel"
  homepage "https:github.combazelbuildbazelisk"
  url "https:github.combazelbuildbazeliskarchiverefstagsv1.21.0.tar.gz"
  sha256 "0b7b5b74cb5d79ba814b4413e59adb826f3891e1b14dfd1485eae2078f531253"
  license "Apache-2.0"
  head "https:github.combazelbuildbazelisk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "445a2e47ca6df5b78ea7c4f14c73f2f637cae825cd1f963b22ad05b1f75dce7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "445a2e47ca6df5b78ea7c4f14c73f2f637cae825cd1f963b22ad05b1f75dce7d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "445a2e47ca6df5b78ea7c4f14c73f2f637cae825cd1f963b22ad05b1f75dce7d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "445a2e47ca6df5b78ea7c4f14c73f2f637cae825cd1f963b22ad05b1f75dce7d"
    sha256 cellar: :any_skip_relocation, sonoma:         "ae2f51ed03a3728bb7160fc511a9bc3508169714336033a2eaa8a3158b93b3db"
    sha256 cellar: :any_skip_relocation, ventura:        "ae2f51ed03a3728bb7160fc511a9bc3508169714336033a2eaa8a3158b93b3db"
    sha256 cellar: :any_skip_relocation, monterey:       "ae2f51ed03a3728bb7160fc511a9bc3508169714336033a2eaa8a3158b93b3db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b968c556bbc13d3b1b3fea1a37e2a0ecdde34f05d8585f904140b02b8cede6b4"
  end

  depends_on "go" => :build

  conflicts_with "bazel", because: "Bazelisk replaces the bazel binary"

  resource "bazel_zsh_completion" do
    url "https:raw.githubusercontent.combazelbuildbazel036e5337f63d967bb4f5fea78dc928d16d0b213cscriptszsh_completion_bazel"
    sha256 "4094dc84add2f23823bc341186adf6b8487fbd5d4164bd52d98891c41511eba4"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.combazelbuildbazeliskcore.BazeliskVersion=#{version}")

    bin.install_symlink "bazelisk" => "bazel"

    resource("bazel_zsh_completion").stage do
      zsh_completion.install "_bazel"
    end
  end

  test do
    ENV["USE_BAZEL_VERSION"] = Formula["bazel"].version
    output = shell_output("#{bin}bazelisk version")
    assert_match "Bazelisk version: #{version}", output
    assert_match "Build label: #{Formula["bazel"].version}", output

    # This is an older than current version, so that we can test that bazelisk
    # will target an explicit version we specify. This version shouldn't need to
    # be bumped.
    bazel_version = Hardware::CPU.arm? ? "7.1.0" : "7.0.0"
    ENV["USE_BAZEL_VERSION"] = bazel_version
    assert_match "Build label: #{bazel_version}", shell_output("#{bin}bazelisk version")
  end
end