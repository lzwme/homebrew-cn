class NetworkDoctor < Formula
  desc "Network troubleshooting TUI"
  homepage "https://github.com/heymaikol/network-doctor/"
  url "https://ghfast.top/https://github.com/heymaikol/network-doctor/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "6c57e191aa1a77674c1942439dc6105cc57c13548477e05eb42d5c114491adb0"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e14df7a43a2cc3717d651b33796d1e126f5f77537a811cc16727898c6ea77b7e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e14df7a43a2cc3717d651b33796d1e126f5f77537a811cc16727898c6ea77b7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e14df7a43a2cc3717d651b33796d1e126f5f77537a811cc16727898c6ea77b7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "ffa55eb8c835355ff74970ce09a87c35638dcac45ac2bf9ae51e44cfbe911f09"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6c591572827d1cecc2d96ed83cda91b451f0d8a9eb47832bcd4aa425c0f3ff5"
    sha256 cellar: :any,                 x86_64_linux:  "8f1a37e04914f4fe8f573167bc113d32efd700897c4959d3bb408f3ed202a802"
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