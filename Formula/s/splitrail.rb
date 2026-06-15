class Splitrail < Formula
  desc "Real-time token usage tracker and cost monitor for CLI coding agents"
  homepage "https://splitrail.dev/"
  url "https://ghfast.top/https://github.com/Piebald-AI/splitrail/archive/refs/tags/v3.5.4.tar.gz"
  sha256 "60fadab1d38ce12248df4a16b6cb6213c11c31300a5f207c2f857c0c52295e34"
  license "MIT"
  head "https://github.com/Piebald-AI/splitrail.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "131580489224907e20fba10ac66a284213c4a598944b1fa039e8ffb615aa4c27"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07264b8f9cd7ef23f49ff9b46310bf0cb104ea496f9adaf41376cca4de038cac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc27a90cf27a484f9ed22f563f7fd30280a9a7207ba369d8f598b8ce99e92a11"
    sha256 cellar: :any_skip_relocation, sonoma:        "185fd83137a41fff50582bfdf4ead346eb321578c3c3296b40dcd95f45821843"
    sha256 cellar: :any,                 arm64_linux:   "d04489ea5514fdbb3e7fc083b88dc032aca9d00356b2cab61e816d899461fba2"
    sha256 cellar: :any,                 x86_64_linux:  "b7b38124f43df509b14bb333b50e3a00042ec309f0002f09e981790445306d1c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/splitrail --version")

    output = shell_output("#{bin}/splitrail config init")
    assert_match "Created default configuration file", output
    assert_match "[server]", (testpath/".splitrail.toml").read
  end
end