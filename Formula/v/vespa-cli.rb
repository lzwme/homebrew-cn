class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghfast.top/https://github.com/vespa-engine/vespa/archive/refs/tags/v8.624.72.tar.gz"
  sha256 "69f630927615059561091af3c452484830024b1ead144f88f5fb936330f67e5c"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e64bb5c738dda5cab703d2784fd0ad06e4f8a380ad70838fd7851c9d7a1c0ddf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7172a0fd0678adb243a0b4eaf5ebfc5e4c07fc78b2bd10f0c0f37e5bb0b115fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0454593ec223822dc166bb1a456ad6197c781105cb65148306b869c70286427a"
    sha256 cellar: :any_skip_relocation, sonoma:        "39eabcab7fe719957a2550e8757b94b6f5872115d7534837abb9798c1889cd10"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db366d20b9a6597bbc2e2e7f1ed9053f49793d6558fcf4c9353040fba19d30f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "671bbfc4d1d8e2db5f800d46fe3fd775e2d14a59f6b6949ccdf8b3cea8360270"
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