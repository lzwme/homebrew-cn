class NetworkDoctor < Formula
  desc "Network troubleshooting TUI"
  homepage "https://github.com/heymaikol/network-doctor/"
  url "https://ghfast.top/https://github.com/heymaikol/network-doctor/archive/refs/tags/v1.12.3.tar.gz"
  sha256 "805405dc3452a0d6eaba4e7563ef2602b54e9d8c94d18954c04fdab16b18b635"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bcfa4627e78038613730c66e961a4ecafbea2c44af76338187ec4681843ccc1e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bcfa4627e78038613730c66e961a4ecafbea2c44af76338187ec4681843ccc1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bcfa4627e78038613730c66e961a4ecafbea2c44af76338187ec4681843ccc1e"
    sha256 cellar: :any_skip_relocation, sonoma:        "d956a588665aa88a1f7895f48f8a79039c0d3a950284bd986b07278bec0729da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5020cc3fe65e9355e28f556fb4f0d8f0d048ecb4975893a2d31685ea2c335c88"
    sha256 cellar: :any,                 x86_64_linux:  "86ab920dbf99e8dd9567a767d5edf73f1320971e5d3674ce45efdcc39b59ad8b"
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