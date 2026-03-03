class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghfast.top/https://github.com/vespa-engine/vespa/archive/refs/tags/v8.650.16.tar.gz"
  sha256 "6c07165633c0d25871be585ad00f76f4a4351fdef0347348eb54dd3e53ae7a05"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c14ff5a9ed8070799accd92516b49e39e8f5b1327c98d3337ce003e46944706e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27cd4903f57624216aebcbcf2daaa44a1d5ce6b1175b64b03e20ede54d114ad1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ea905eb34eeabb4867b5aee82a20852cb32b978ea4eed86faccc6a113132f61"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5496589a3aae3ffb087aea2ac5fc815e28cf8b45b2ad6495d6da2ab2a366515"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9504aaa468f3a8b1885add15ecca4fd408eac108da3314a78158dc1a3f8d3e26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c79eb0999ff33ab2f8162efa254527ca96b9798c549b7fe674561e5ba716b55"
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