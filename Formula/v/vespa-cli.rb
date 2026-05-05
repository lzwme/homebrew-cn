class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghfast.top/https://github.com/vespa-engine/vespa/archive/refs/tags/v8.682.72.tar.gz"
  sha256 "3e29bde1399066fc0735c41c79749ab31bbc8b1fdc432bab18bc0b2ac95f1a62"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8603cd0e5240349ae4793916f604c66727acb23fe93838b0d789f01fb6c4b8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5327ffb91a9de7160e0f2a6e9d8e9789862199acbac3b7fc8fba47cf275ee189"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c62dfa2dcfdf6316514079eee96af3212789b4221c9ea03463df85ac57d5ed0c"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7210ef0d177821e470afb6ec36ffdc89b66a638dc258b6e362a09999cf81338"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a11879993b1c39032c6f7afecd107a7a471ab41d62b08c8957c7c79fcb816f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffb9e5a69af3f138290e300999ec780ca01ecefbf71d15ff6692dd5ec133215c"
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