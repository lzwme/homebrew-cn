class Bazelisk < Formula
  desc "User-friendly launcher for Bazel"
  homepage "https:github.combazelbuildbazelisk"
  url "https:github.combazelbuildbazeliskarchiverefstagsv1.23.0.tar.gz"
  sha256 "8a2803184e77bdcb9116943d33ab82e00411b440ada2384e2ace783f7047a804"
  license "Apache-2.0"
  head "https:github.combazelbuildbazelisk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b82619536ef86dd93e6ae714d8f9b51c4c915d48b72b52e98acf616cc7ec30e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b82619536ef86dd93e6ae714d8f9b51c4c915d48b72b52e98acf616cc7ec30e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b82619536ef86dd93e6ae714d8f9b51c4c915d48b72b52e98acf616cc7ec30e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "caafad29de5806e10bf5877d7749287546683d3d3186f8627dde4393333ddfc1"
    sha256 cellar: :any_skip_relocation, ventura:       "caafad29de5806e10bf5877d7749287546683d3d3186f8627dde4393333ddfc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a04db6db3c673008db022207f3bd446befef65ed328de10ce83e857189fac288"
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