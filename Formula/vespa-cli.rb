class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghproxy.com/https://github.com/vespa-engine/vespa/archive/v8.158.10.tar.gz"
  sha256 "87b56c5b02609e4d1bea1ff5b425bf0bf3fcb3837d2430bd0857715b67233fae"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3291d1c97af1f7a16e4298c16e2e7b913337379611ac1a85a67d8e4ffc262d08"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "025cd4dc0a4786e69436e756ca998fb12acb1537d98a100c85e0ae329550823f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "24b03c26da551d3372166066adff523f254dde4137b32c6a161e5b859a5ba665"
    sha256 cellar: :any_skip_relocation, ventura:        "6e6315c62e921587a11cff764ba846ba839cf6909d92a83f7c64b135dc9a9d66"
    sha256 cellar: :any_skip_relocation, monterey:       "2cb100567deffecdb12487eee58310ddc2ccb7ca2e3c378501bf9a48d0fe93c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "d4bbf54c90a36f025ff7f51b0f81695dcf3d01a9ba4aebc835b86dd7384d8a37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90dc26d187869467f4c87afe0614a8122028eeb365a43ab8be252c8731aab568"
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