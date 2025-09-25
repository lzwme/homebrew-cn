class Fblog < Formula
  desc "Small command-line JSON log viewer"
  homepage "https://github.com/brocode/fblog"
  url "https://ghfast.top/https://github.com/brocode/fblog/archive/refs/tags/v4.15.0.tar.gz"
  sha256 "c2f56c9e2f4c5fbd8b36cf1611905255a0ec1db51b8eea49d1c0db779a4949d3"
  license "WTFPL"
  head "https://github.com/brocode/fblog.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d880eb47bc2a35f50be3b559861893f44ed2ba1605ddc94e23ffd0794685962b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "659c69b889b5124faa6929d2c16b168e04efa56c3cb7f89ffd4ceb1fb4f14a87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7281d67ebb14e70e729b18ff52acb073c5ea4ccecd52e3dc5681a2272f5834bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "962cf39cf3694ed371cf8d07ebf32f9dca500a5227b7c73892fb7bdc400c0b1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76407016421d9b0151af5fe33e7289c2ecd9d30a1e3920e3e62590d3005d412c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c1506405883fb3390fff3380668015d7875296e04a8effe74322dda2de65f83"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"fblog", "--generate-completions")

    # Install a sample log for testing purposes
    pkgshare.install "sample.json.log"
  end

  test do
    output = shell_output("#{bin}/fblog #{pkgshare/"sample.json.log"}")

    assert_match "Trust key rsa-43fe6c3d-6242-11e7-8b0c-02420a000007 found in cache", output
    assert_match "Content-Type set both in header", output
    assert_match "Request: Success", output
  end
end