class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghproxy.com/https://github.com/vespa-engine/vespa/archive/v8.223.15.tar.gz"
  sha256 "910dee49eed207d2938cbd5ba509e775c0b412a5ea7427e2231632b7d87d21aa"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e6f8687b66d05ca4314dd11d105083b6c90e7c0a7a38cd432c9977bdd906e65"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e75d843267f435e7133b7e75bd70a2376feac79da099783e0acc18be6f91eed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "91da03e4bbd911b3472666c13442daddeffd7e46ed5dae25195c85be6034195f"
    sha256 cellar: :any_skip_relocation, ventura:        "35316b1f6b019cced50d39def4046141b0d4d1abee79f4af38da0af858166adc"
    sha256 cellar: :any_skip_relocation, monterey:       "85e1434c09a651cac7cb6339cae15664047f1c9f36150275941c5795175e83ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "f97914df94939e8ba98d85fe1bcd6fc22608c58b2e8e7b5c903173cd7e2c81c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c149228a92cb183deff3d54c0a8bc4a142a22bb54311f3211077022601689bc4"
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
    output = shell_output("#{bin}/vespa document get #{doc_id} 2>&1", 1)
    assert_match "Error: deployment not converged", output
    system "#{bin}/vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end