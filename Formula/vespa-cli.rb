class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghproxy.com/https://github.com/vespa-engine/vespa/archive/v8.157.14.tar.gz"
  sha256 "ad0421383e1ec61e5841025d7bf938649b98f1a7489ad887837c4cea481a778c"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8fcf5c6d1269d011ecf2e4ebb02bb91dd690961c7e00f417de33c1603121b2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9d145a54855de4989d570eddad53de1c1636c199736c33feca20e73419edaf3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6342bc9507e8e001b7836e4e3ef813ce6c8423861a7c3ca9011285cb044e1ad5"
    sha256 cellar: :any_skip_relocation, ventura:        "7e863c0354a8bb04f41588aae896c2b4390324cab4d6fad8c55310a5c689c94c"
    sha256 cellar: :any_skip_relocation, monterey:       "8d03f5ed173dc533db3c89348c379fadb5f39bff2e3f42218864b310103c828e"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce98594dac8fcdece0fc030bdc056ed2df53ae7165b4ff89cebc0e5f00a633f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1342b288c0e5b63b882c2f635d1ddb72afafc22fa3d7b6391a075df72f319e3"
  end

  depends_on "go" => :build

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s, PREFIX: prefix.to_s) do
        system "make", "all", "manpages"
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