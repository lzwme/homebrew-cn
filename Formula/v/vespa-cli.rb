class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghfast.top/https://github.com/vespa-engine/vespa/archive/refs/tags/v8.665.18.tar.gz"
  sha256 "2c218711070c276864b81fd5ae7459a683006d1b02f79802009e35dbe8c18d97"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b327a6fb2b8c3e97389a903511c42508da69afb188ca1abf9d6e8ee3e308e2f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "286e7d81cf5d1b0c7a3a4f6d50c7b978148b6c7f0bf20d0e03e44e57210ce88f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "192702c678ca06036a37534ba8ea9c13e91379f5a502326be6e816f08675cc61"
    sha256 cellar: :any_skip_relocation, sonoma:        "984440b9c406c3fe925775e744b0dce88e059f54e9c5ebbee0e5013d23730959"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf419111e444a53465a579c2d19f0729969da8662acc2a6f19e008c3024e4a5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "289aa28d01750a29258d8b86f7969c22a0879798b6038c90cda9384f568f9ae6"
  end

  depends_on "go" => :build

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s, PREFIX: prefix.to_s) do
        system "make", "install", "manpages"
      end
      generate_completions_from_executable(bin/"vespa", shell_parameter_format: :cobra)
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