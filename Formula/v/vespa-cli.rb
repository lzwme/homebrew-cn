class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghfast.top/https://github.com/vespa-engine/vespa/archive/refs/tags/v8.591.16.tar.gz"
  sha256 "00248ab7644353a0afbd2e295f4a897dd383a8d8a87ef31717bedb8e09da17a3"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b1324359f974aeb6dc323984fde40f5e7a835fb76e1e2312240298a317151c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81722aaf1884ea128c02f1a1fef82335334c25c567a4a23ec06b661f620bcce0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "086dea1bb6caa0b9f2062da7e49854efee5124f829e321fb2c500cf9d525302c"
    sha256 cellar: :any_skip_relocation, sonoma:        "8df4ea4607b197cd21db1b341af9869e6aade2067d13030684a2b9f268e0ffdc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff5f0064aff9fb3b00548373b65b90a074e91898da8d421fed582788b508db47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b590ba4039476d06adb3e6076c13f90c06eaf2de202ee8179e026417a57e64e0"
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
    system bin/"vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end