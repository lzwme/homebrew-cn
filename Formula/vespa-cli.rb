class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghproxy.com/https://github.com/vespa-engine/vespa/archive/v8.146.12.tar.gz"
  sha256 "f875e23de15758ed0d06065f8742744f7f769a268d690e97f05a25faa83a3dfb"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8422b13837fa0d5ef02b113a94b59b258373723f49f857359db2bfdcb8f4aee1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ac28e9266acbebcde40b449a441da52aaec4c29ada3b73560bf3d25f199337c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa2cc82e90ba40d36813320fbb4e39708210ec9351fea92ce3313825069f6c9e"
    sha256 cellar: :any_skip_relocation, ventura:        "d4e514269131cb851379ff6b8af0db0f98065ab1b601f45ec36203dec0fe1ef0"
    sha256 cellar: :any_skip_relocation, monterey:       "30f81db21556e93c70ba73d43887a3f589a863aae1109db1401d46cf1024fbb7"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c7f39302cbeb1d7d3ec04e878a2786e7159245fbb786e49dfd4854a29e8a68f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18d6d50b6e1725827f65b5654d635b597fb20d92da2b8ec69701094652654b16"
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