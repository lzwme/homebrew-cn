class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghfast.top/https://github.com/vespa-engine/vespa/archive/refs/tags/v8.599.6.tar.gz"
  sha256 "2bfcdc2d2eacd835e93c83076668fa9a532d6c7e0a70f3f512bd85f2f9412763"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b48150ba6a70175df2a7c61e084653cab834bde17e44a025369be1ba28ab23b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c47709beac2c48cf89de055f5d35ecfc075a5eb082f23eb36b6792de90da0197"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76e712f1b2764e074d0fb5e7dd7117c5e00c27b376318fdd6439afcba88798cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae03f9dc2deafba63943f7684a23e9b005d93c0ad689f1508a81a522f16f5dd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a801e19f8e0de5eb6fd4a73142224522a3ef0ad55253a2d0303c8c825dc9f2bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1df37a9fc23ee8b8ba3c0383a331af52dc7bb577edb91557519e3548cf5b56c"
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