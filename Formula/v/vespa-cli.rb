class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghfast.top/https://github.com/vespa-engine/vespa/archive/refs/tags/v8.733.3.tar.gz"
  sha256 "74b84d50367a1bd87d7cc95bbc1911e0ecc0642df4d8425581a36ab036297f5d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ab8c3022901a6738b82327841510987b44df0f0b679e20bec988d4d47cdbaaa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0befd1e8d46fbd35670ad49742c77537594bcbd071c3e613f637f700c22c9c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3ad3a9534c7ae2b1cbbc5f42ae434b88c9058695aaa642aec0db2ca2b804cf2"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7922ba9f7d03e138093077822cbb2a4c495d1c3a5ef8b913f4c9dca079e8083"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1e276ce57328605204f4ed0f60c84348e6a88cc46d4a679674c1d1619c19b36"
    sha256 cellar: :any,                 x86_64_linux:  "2eac997de6340d89ed4adbebfdac73b5a889bb365408a7ae270a3907ce40e6f0"
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