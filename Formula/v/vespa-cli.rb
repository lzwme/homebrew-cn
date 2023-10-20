class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghproxy.com/https://github.com/vespa-engine/vespa/archive/v8.245.22.tar.gz"
  sha256 "57aede777d2791caec875075ea5870b2ebdabfef0789f141b86dd19351d520e2"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ddabe96e699676664249b4a3b6cd5760a7ec68d331bea93691eb5b631f6dceab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cca4e622ea3b1aec0b56774caf91cfdfff140b3fc8aff395bf0bbe6c290d1913"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1a45062fb6f9f002ad9a48c7f9d82298b4c9902dd8add69a6bf8d4e7586a506"
    sha256 cellar: :any_skip_relocation, sonoma:         "e490407ca6c83b2fc4131baccdcdda84afc676fd0f65e02cefbbf256903796c0"
    sha256 cellar: :any_skip_relocation, ventura:        "2146927c35ecd570291cb20adcb05d005ec50296a5d3b8d85cf38db9df90daf2"
    sha256 cellar: :any_skip_relocation, monterey:       "3a78c83097b1acfc45adb761219ce36b98b198648b2d6f930c4b0a49a550fd24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d3e62a614bf97498e315f1759ac387a07ce93f402b00d5d5745eb3d20f3ce17"
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