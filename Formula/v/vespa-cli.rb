class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghfast.top/https://github.com/vespa-engine/vespa/archive/refs/tags/v8.646.22.tar.gz"
  sha256 "e711d30f88108e9cee494b064a0f7cbaa6e0ae916e20e4a210f9429d467fd07a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50070dc5136d528281b8e6bc36a1a7e27e25f231759622bff5873fdba0e65613"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c78cb89fe0477dd9a6ad91127214daf44bde36b21bc2c47ff6ab7a8f0d62fce1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2738c3c02c44ac9cbce2f8bb03fc8169c03c67330a6d90e13d0becb79dca992f"
    sha256 cellar: :any_skip_relocation, sonoma:        "7cd0d7371d5dc107ed69e09b1537f29b60ebb63e1d74f0ccd914c351ad277e73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a544277abf1a3cc0d71d33087041b6184bb52722acd6159c68073a195377a1e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14646a4e27f5af050c67b9707ab66c86b11d0a77f63fc856710501d53f9276c6"
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