class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghfast.top/https://github.com/vespa-engine/vespa/archive/refs/tags/v8.648.10.tar.gz"
  sha256 "de7e5cc160f4fec3284d09808b7538a5eca3c5ae3942230895b500c4f3d5a153"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab280051f2f7f24a72ca7849127c069015b0c170c62fa6b3efb2c734fc846f1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "baf6b9d7b2ddee1fb3088b0f733da95e177df45c8a24aaf47dd110433c0d01f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59d115f8dfc9f712327bb796b4a31e9331a394bad1e3e6f68955bbb33577cf53"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ed4cdd413a082bee1b95567b2ec01187b453cff4c1e1d437feb26d4bd38869a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a86dcfa9a079cdadea853de8ae85c4c2f77c1aa7dc753131862cca34008ca8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48ad55d6bfea96a8737844dfe18460d724869c8efd3fc861afed37a1c876731b"
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