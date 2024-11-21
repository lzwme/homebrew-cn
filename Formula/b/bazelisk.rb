class Bazelisk < Formula
  desc "User-friendly launcher for Bazel"
  homepage "https:github.combazelbuildbazelisk"
  url "https:github.combazelbuildbazeliskarchiverefstagsv1.24.0.tar.gz"
  sha256 "54d31b53f8638c8b717e802736f9a478e929943b7e9d3bc6f9cee7c82b4302ef"
  license "Apache-2.0"
  head "https:github.combazelbuildbazelisk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f8ea1fdecb3a56f01aa166cee1d841581ca2be9cbddcd04ca975151ccd04443"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f8ea1fdecb3a56f01aa166cee1d841581ca2be9cbddcd04ca975151ccd04443"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0f8ea1fdecb3a56f01aa166cee1d841581ca2be9cbddcd04ca975151ccd04443"
    sha256 cellar: :any_skip_relocation, sonoma:        "36040fa8759e342762ecf7f232d54cbfbc39265eabef7060ad39efc89e5aa23d"
    sha256 cellar: :any_skip_relocation, ventura:       "36040fa8759e342762ecf7f232d54cbfbc39265eabef7060ad39efc89e5aa23d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "391bec6183afbcf91572a54322c7c547dea14dd580fd7484841131910e06eebe"
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