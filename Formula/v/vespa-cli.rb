class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghproxy.com/https://github.com/vespa-engine/vespa/archive/refs/tags/v8.262.17.tar.gz"
  sha256 "41f7291ca2eb9ec324ed249cc2fb411c54a09d60e607704f89b552e6072cf8c2"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2d3f5b4db909f41440a4a77fdd6e7d511d6d13bf184b4d6c5b3579a3117de424"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9d3e484ae5509249251d8a82da3c970166896909ab788c5e197a8b05bd78319"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d89d60bb3575f89bcf8b2f3496be5ef527006db09186f0a8a209c99bed4841bd"
    sha256 cellar: :any_skip_relocation, sonoma:         "83f9894bbfec33cb3e9157665103c66bac5c1fbcf0e05c8cc68cf98544e771a2"
    sha256 cellar: :any_skip_relocation, ventura:        "9a46431ad59cd4e152e485f5205f701b07cb681fafeb46719c0c8d4ec513bafb"
    sha256 cellar: :any_skip_relocation, monterey:       "03f92a567bdce3d7f2bba0ad406174525c00a2b58cfd27d993a3936bf346bd93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a35d2640d55be8e1d9839f0e421f75216465e37f62ed084afc0d3de450683967"
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