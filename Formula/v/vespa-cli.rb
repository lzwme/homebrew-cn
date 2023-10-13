class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghproxy.com/https://github.com/vespa-engine/vespa/archive/v8.241.13.tar.gz"
  sha256 "61162967cb2b243db6b7f1f09a464fe01edc66fec8c240dcfbbd52014b34eed3"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "176a1b004e35f7bc408a3d7175982f7c8c8843cf514171b972f59c1a364bd397"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41ea06fa46a959cd56e1e5829e1ebaf41e9a3f88d50ba4a5a7eb0485b1024e2f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7269fabb541cadeb05560a6031addcaf3340418fdd64f8da5c3aaf66ae03f5e9"
    sha256 cellar: :any_skip_relocation, sonoma:         "65b42d313f516581c03e7a200350c260330a2592a228d442082e8c5cfabb1a92"
    sha256 cellar: :any_skip_relocation, ventura:        "eb0433d1e84b132802008722719f77192ca763b72ecec9464ccd996bed9be34b"
    sha256 cellar: :any_skip_relocation, monterey:       "70631a0108527cc7785ecb83f7ebd50f0a27c307501ae3af102b9acd6729a2c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d39f45f12fc460d1d486a0f992ff3b0526d768f4964cbcaa40dd6c977346a0ae"
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