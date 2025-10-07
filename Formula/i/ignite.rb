class Ignite < Formula
  desc "Build, launch, and maintain any crypto application with Ignite CLI"
  homepage "https://docs.ignite.com/"
  url "https://ghfast.top/https://github.com/ignite/cli/archive/refs/tags/v29.4.1.tar.gz"
  sha256 "be80089add623fc31219cb8e3df322a6db5325a1540d186ad3e87421335e6270"
  license "Apache-2.0"
  head "https://github.com/ignite/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e2ea850d1a09d7f7cbeb696450339899aa8237d84ddca9da7ebbb303604bab37"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebfef21ae8c1362a0fe6d4df689c76b9f1a5fdea720b1929426f9f754b895293"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c205d3c82cb44a4c9a28619f2ac401b858f7025a2f9666d4e68b8d2f0bbea43f"
    sha256 cellar: :any_skip_relocation, sonoma:        "03c2ec2e4105e1db9fa329ee43369b3eb0ce56cf90885a853b7d348ab630e383"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ee7fea79341d2a28d0aae55b7100ab28723995ff6d5164bb7e04c2e5222441e"
  end

  depends_on "go"
  depends_on "node"

  def install
    system "go", "build", "-mod=readonly", *std_go_args(ldflags: "-s -w", output: bin/"ignite"), "./ignite/cmd/ignite"
  end

  test do
    ENV["DO_NOT_TRACK"] = "1"
    system bin/"ignite", "s", "chain", "mars"
    sleep 2
    sleep 5 if OS.mac? && Hardware::CPU.intel?
    assert_path_exists testpath/"mars/go.mod"
  end
end