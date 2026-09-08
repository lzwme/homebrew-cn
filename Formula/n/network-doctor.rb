class NetworkDoctor < Formula
  desc "Network troubleshooting TUI"
  homepage "https://github.com/heymaikol/network-doctor/"
  url "https://ghfast.top/https://github.com/heymaikol/network-doctor/archive/refs/tags/v1.16.3.tar.gz"
  sha256 "6592f3ae53a66b2cc482253a138969340bcae5a43f9b1a1b623e6779be18e99f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7fd6cfae4b1b3be4d6bcb3ed81bb00ab66992cf76d2e989175254d1b517e396"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7fd6cfae4b1b3be4d6bcb3ed81bb00ab66992cf76d2e989175254d1b517e396"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7fd6cfae4b1b3be4d6bcb3ed81bb00ab66992cf76d2e989175254d1b517e396"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27a9480e34d7f414fb3695fe33adb0f712101972a97ccc09a91462d454819906"
    sha256 cellar: :any,                 x86_64_linux:  "a9c52865eb079447309ecb0d751a3bb6366e09eeaa4d24dd38c51d05bf280e3f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}", output: bin/"netdoc")
  end

  test do
    output = JSON.parse shell_output("#{bin}/netdoc -json")
    assert_equal version.to_s, output["version"]
    assert_equal true, output["checks"].any? { |hash| hash["id"] == "iface" && hash["status"] == "PASS" }
  end
end