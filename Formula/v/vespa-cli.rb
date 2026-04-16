class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghfast.top/https://github.com/vespa-engine/vespa/archive/refs/tags/v8.673.18.tar.gz"
  sha256 "40e44fecf3d28f027f0e786d2c1b136378a1cfcc8da1c5421a00dbaf21033158"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0cf6c4182f51c76edad99a5c9b23b5ecc3e86ebb217d3018c1fdc4a62f61333a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53963c9a58e46e841254d86aeb46a53ef908a041cff263c805b003e4497a66ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e364b00df969453a97fcfbdf4667abf49888923914efab86443c7531438223e"
    sha256 cellar: :any_skip_relocation, sonoma:        "83b3b921868346e64f0bbff5883116263f93c7e4712aeaddfaf570e4e206b445"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7bf8450d8facc380d7d6026edf73af61c33c56ca8000b008a32cb2a0f2c3ae51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dcc527bfa79ffb6da2282bdabc1114f3f69861465502c7557afadf62d5081034"
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