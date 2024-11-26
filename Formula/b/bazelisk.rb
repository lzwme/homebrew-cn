class Bazelisk < Formula
  desc "User-friendly launcher for Bazel"
  homepage "https:github.combazelbuildbazelisk"
  url "https:github.combazelbuildbazeliskarchiverefstagsv1.24.1.tar.gz"
  sha256 "c7a44600ae88732fd75d8cbd1d58efe69610e41540566ff4102c5e3b96e497a7"
  license "Apache-2.0"
  head "https:github.combazelbuildbazelisk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0bae555199c22e743265ddbceacfdb1b02eb95219524bc8725fee548f0cce34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0bae555199c22e743265ddbceacfdb1b02eb95219524bc8725fee548f0cce34"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e0bae555199c22e743265ddbceacfdb1b02eb95219524bc8725fee548f0cce34"
    sha256 cellar: :any_skip_relocation, sonoma:        "58d895bc81f10a256160bc6b15a5681408cc74c12da4674d2f1f2b9214d03b8b"
    sha256 cellar: :any_skip_relocation, ventura:       "58d895bc81f10a256160bc6b15a5681408cc74c12da4674d2f1f2b9214d03b8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9349dc52707a43f29c61cf1f6eab004a6f10f9e8a214044933b9e81a88e9989"
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