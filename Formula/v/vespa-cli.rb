class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghfast.top/https://github.com/vespa-engine/vespa/archive/refs/tags/v8.730.36.tar.gz"
  sha256 "1ac96b8fd69dba61abb8ad130140dbc7ff676b8a1ca95b1b7111e8ce2252a6a1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8a14a26bb829adb3f8f0c438688e9e95124885df3bbd43b6e3bc5e72ebb6f23"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e8b12c1fc777cbcbe49c5674aabec9675db66ba200fbaae1b810d5dae6a12b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4304c4ef0a7cb49e3133b7eeae2bce77bdb29e349a6a7ed0679b5650213cef82"
    sha256 cellar: :any_skip_relocation, sonoma:        "4593c594f395c11c03563a0f20819fa745283749a46d3596bce130684e995c7f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1f362c51c4e9fa0211a2247b5b6b810b9713dcd7eaf708f21b2ee755127a804"
    sha256 cellar: :any,                 x86_64_linux:  "7a9194da9d7b2a38605d646b6f95bee5e703046158684bbd51cdf9f52b28aace"
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