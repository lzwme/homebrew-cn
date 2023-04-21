class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghproxy.com/https://github.com/vespa-engine/vespa/archive/v8.154.35.tar.gz"
  sha256 "12e5961f640b3c5ebdc7b1b1760080e4f1f131e7939b9e095080482a40b99660"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93fed42d668fcaced5c80d8752f5dc7156859dd38d8d502d44f5fa9a04793e15"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "999d1e9abbb28a9256e79faed680c96b5b26ea5ada2179902665236ebc6150f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "06cb2b43564228679cc09e0332074cff94b0ebc725d4da90634193b872b87cd9"
    sha256 cellar: :any_skip_relocation, ventura:        "49c51fec539d73965c67822b7f9f129eb43c5edeab403a8bbb5c085247251151"
    sha256 cellar: :any_skip_relocation, monterey:       "81fef50135bdfada33a3f3508595358a9b95f8b8c34abe16b5e9039e6e2af556"
    sha256 cellar: :any_skip_relocation, big_sur:        "57663650b8c02f7b306d315ce7a0bf170b9b79e6f3941a3038a0a8f2b153ee2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39343e608f3ba646de8bf2ad65a50676c52d441bebb88c16da0617f5cc75d115"
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