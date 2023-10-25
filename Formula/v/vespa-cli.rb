class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghproxy.com/https://github.com/vespa-engine/vespa/archive/refs/tags/v8.247.19.tar.gz"
  sha256 "6359bd899ac6f16ba119c6f6044cc79b9b22a772bb734df8adb6edb273977968"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d7b4c4cb5f1f7bd85d8121d73fede60c59c6a532856048007f66cfaba4cd3130"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cfc3e44f342081d660e36f0ffe58a7f6f9e83493f52ea4117130de0d068e5ac2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad84b7ce2c739ea7c85ff0e74610ee3d9b4ac66ff4057be45a4f2139852d0ec9"
    sha256 cellar: :any_skip_relocation, sonoma:         "7146c95bb680f2bce8e1ab585bd14f4a335e30343c40902e5814cb3749e9104d"
    sha256 cellar: :any_skip_relocation, ventura:        "e716456dddd6128167422ebcb92f5c295a32a0582b0bf06beec7aecc04b9a7f8"
    sha256 cellar: :any_skip_relocation, monterey:       "2a1ef6e927ed1a4054b5e50f46b6079804353b0fb090582d7efafb135b20e88b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14f32678e79c572b235ee5169e27b149c08cae0db6e374ac4e3add86656b01d4"
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