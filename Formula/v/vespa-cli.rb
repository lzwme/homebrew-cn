class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghfast.top/https://github.com/vespa-engine/vespa/archive/refs/tags/v8.692.16.tar.gz"
  sha256 "378cfd12ea8abb8273e526a402dc2cf3ac9be606022f9652de3827db72172548"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4371173e7838e97d386011d9e250e5326c62b952f7540ef1a7572c00b7d21158"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce8981070169d3e20ca6d1c22d61cedcdebd8f82abbc5ca11695a35beba91f07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad5826ebb1d168657198bbc755f7e36cf9c215d0e64f8d35cc4f410f38584955"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab31cd4787c39327b35e34d80bd5ae1a70b4b491c7681512e892d38420f94316"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12e438656ed80fd207cb98f60265c0fd195ce7ec0f153a0cc4de7e00a78539d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9f184d4c247f485fef11f944c353052c6ed7b861260464850b3343a9e7cc7ea"
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