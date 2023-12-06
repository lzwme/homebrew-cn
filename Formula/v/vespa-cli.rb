class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghproxy.com/https://github.com/vespa-engine/vespa/archive/refs/tags/v8.268.18.tar.gz"
  sha256 "d94310f5de1c32cfe047c8041643ccc3db25d2b1b29a100a90b959860aefc5dc"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1727b6c713da6baa4741e6f523d143da3e5905d9e0a853225fea13ee7cc145a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "418c7352a7329ee8bb7a73a001fbfc94581b1c9313841502d44fba0f383661f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d696d8f7c9c33502f39fd08b274e7e15abbdfd62e6ed6c309ed38e55321f016d"
    sha256 cellar: :any_skip_relocation, sonoma:         "3efd904ff63cc60d7ff8a1b55e8917ab6abe8af43916301fa49ce3810faa2ad8"
    sha256 cellar: :any_skip_relocation, ventura:        "daf1c6b74ccf3a06729e9fbc651e8ee523aad1c19d4437f5b6385a20caf72f08"
    sha256 cellar: :any_skip_relocation, monterey:       "ce723399c837254f931ba945312126bc8a5b6d09e1e1d01974f0e3d6e0d84554"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50d01c6e377474f6c264099374a44a2b464f716fd82bfb498dbe87e0dce1b77c"
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