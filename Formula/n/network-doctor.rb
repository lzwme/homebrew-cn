class NetworkDoctor < Formula
  desc "Network troubleshooting TUI"
  homepage "https://github.com/heymaikol/network-doctor/"
  url "https://ghfast.top/https://github.com/heymaikol/network-doctor/archive/refs/tags/v1.16.1.tar.gz"
  sha256 "7593def330e7d4dfcb24eb44c451f4e078269e8738ad89e3d84c7031945eeae8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e774aeabe6c839386d13ad602620d475ec98167741ce55165a9d1ef5471e016"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e774aeabe6c839386d13ad602620d475ec98167741ce55165a9d1ef5471e016"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e774aeabe6c839386d13ad602620d475ec98167741ce55165a9d1ef5471e016"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aaf69cf10b40ebaece9ea82bcbf8f907655181627c64000128ecb2832ec700ba"
    sha256 cellar: :any,                 x86_64_linux:  "ba7490214ecc5be91a6277a16c4b647eb4d11509c57a897b9394cc4af14cba61"
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