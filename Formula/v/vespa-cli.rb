class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghfast.top/https://github.com/vespa-engine/vespa/archive/refs/tags/v8.736.12.tar.gz"
  sha256 "8834e1cdc937372975681048e01bf9f3cc43869bdee2b338d9a0c0f3970b1a56"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "287f637fd4f6e4ea04fbcb4ee7f8a22d5dcace02d7e5a76a1d146e6ae848ca90"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "281c4190b33c52136257a242776ce68dbe9df471980b690af67de79a1cbf8f59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72fce8e2633ad96effb9513552bf78030800e8ec47ce0f72daacba0befa90499"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d4377b343efe33c5921b4bf0e539df4cea15e6c8cad946adafdc893cc1bc83f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cedbc82cd98bf06026cfa217554f957910c5ad6acef1eab83655d25dc75339e3"
    sha256 cellar: :any,                 x86_64_linux:  "11c96c13d53d39529fe7f2493dee686b5d3919d25529977c62ea2c0faa0a1f6a"
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