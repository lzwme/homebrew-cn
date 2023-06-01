class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghproxy.com/https://github.com/vespa-engine/vespa/archive/v8.168.43.tar.gz"
  sha256 "7fcafac8c43c969f01c26dbb306f5ec2a66917e52107b832e8264e9643ad9d4b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "207a57fd9c6c6c827b26aaaa91c520c3fa04174696c9667f172b3dbe3c0a3d5f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c77cc8455fe5541868f70942bbffb7b218af74713f5939ee9d25e40f0557bae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "93079c477c2303e779b8ba9c64572e6096fb7282fcddb167b4d8607c64b40c59"
    sha256 cellar: :any_skip_relocation, ventura:        "8dc4b24ff14fa398e50ef073caec57ed2557cba5397dd4b306d1a2e63fb29b0d"
    sha256 cellar: :any_skip_relocation, monterey:       "9ee073a2aad6aac0204d04e30eb924009528136de9c85804ef6320fa6562a4c1"
    sha256 cellar: :any_skip_relocation, big_sur:        "6178f13740e936d2056d3f10432a5dfcc13f0f261e3c097d5d390a421c22bdfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14141f5ab41d8611c2156069f67d7ca28b6a1dce083f69426de20b2c1dc3bbc8"
  end

  depends_on "go" => :build

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s, PREFIX: prefix.to_s) do
        system "make", "install", "manpages"
      end
      generate_completions_from_executable(bin/"vespa", "completion")
    end
  end

  test do
    ENV["VESPA_CLI_HOME"] = testpath
    assert_match "Vespa CLI version #{version}", shell_output("#{bin}/vespa version")
    doc_id = "id:mynamespace:music::a-head-full-of-dreams"
    assert_match "Error: Request failed", shell_output("#{bin}/vespa document get #{doc_id} 2>&1", 1)
    system "#{bin}/vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end