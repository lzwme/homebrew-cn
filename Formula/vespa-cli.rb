class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghproxy.com/https://github.com/vespa-engine/vespa/archive/v8.149.36.tar.gz"
  sha256 "3236b88156d797d0cbf2f4e03a5d3b89f451543df107ade9569d0fbfb2024d43"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0a32a9fba74fda3409acc4d5d2b8a7b5dbb6208025a327c0916f61a7383bb18"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0f72ccb7ffcefdd8fceca2e890f0a4ac0c1e6841541da2cf8552a1ef18c977b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b9b048d98ac30883aff690fc115866b2ede93372ebb1ac6ea670427bb030ac71"
    sha256 cellar: :any_skip_relocation, ventura:        "747d47e42d352aaaf826de6deca2c2ca133c3b959325c60952e7f765687eb452"
    sha256 cellar: :any_skip_relocation, monterey:       "f9a730d1a4bc606a53c76c90b60e8cc5988ccca06527267aa5cd79c8b9aaa14f"
    sha256 cellar: :any_skip_relocation, big_sur:        "130fb9403ab03818b0e2dcb029def729b716afc68576a16a54cf310c28f718c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2120a138e29f6e35c6a6c78c20c5ebe19564a97383cfe56a27cfb63ba8e499d8"
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