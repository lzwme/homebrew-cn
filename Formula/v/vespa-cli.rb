class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghfast.top/https://github.com/vespa-engine/vespa/archive/refs/tags/v8.653.22.tar.gz"
  sha256 "ed8d942ffa8cca7868e645b8ff86c2dd8e7b1871f905e92e39996bbe06932ab8"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "04e7b2ebb7a4fcb376a4287d8faa32901cc312413fd3712943daeb97046795ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc927ca1d3dc5f41ced1c6978494d56087d683ddc1a8332849a3a3a00180b1f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53af9fd73ba175966998ec951c2ee4859bdab34a63e20f6c81fdb410ffb1e9a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "f53c9e938d1078a62f9657523296fc78c934aab71d64efde1aa5015a1fb0986e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a094724574653b6dfcac0be2664ae6376f95681513fc07ca3d74e687dbd08ac2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e641c8458cc25257eb94a90fbc8923794ab4779204dc20aebe626c5585b3cc5a"
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