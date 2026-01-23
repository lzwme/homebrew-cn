class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghfast.top/https://github.com/vespa-engine/vespa/archive/refs/tags/v8.631.39.tar.gz"
  sha256 "581cb632ae2124406f34cc1580977fbb3fe1fc488345e9dacf27a4a4a347793d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d2f3ae927c55bc7f6b355255c6f7c668de62b65a37a8bf4624ad68620342742"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b03b0671bf551ce3f7494705e0e10ec95dae7304ce90d9d31709e0abd341b86f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6121cb0b7a33e47f9d2b5178f67c3fc1f1db33d9c242db867ce4e3d3a24893a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2de86074b580eeb3484fae168a07d6dff2b5ec8adfa3c253e95997bcd398770"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe440f4c49936be833ee361d0f3d84a67f94a05453405f9a66e08793a1e1d04f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02ffdb9681531c5d741a87aad74b05b3b348945f97ec701328b7236860c93a3e"
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