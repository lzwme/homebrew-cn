class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https:vespa.ai"
  url "https:github.comvespa-enginevespaarchiverefstagsv8.367.14.tar.gz"
  sha256 "6b38708c8c451eb2abbc44f7895311a31ef1e1dc4ba2273fa66ce119ffdab932"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(\D*?(\d+(?:\.\d+)+)(?:-\d+)?i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f21c98ba53d1074b2b49360d7997fb3a640621cd17a5529443863166ef0248cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b45ce9d5416be44a7e655798bbe740ed964700c36c3c3dfd543bb5a3229e08bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d112c79301939b8d46db0317ec2bc3129d4874f02169927a441bc7cdc07216ff"
    sha256 cellar: :any_skip_relocation, sonoma:         "fca01800885ad649ae67a3be4de998c09bc566c96caa185bbe320d02c786e40e"
    sha256 cellar: :any_skip_relocation, ventura:        "59fcfaa0b2f5649f4fad01c073672db2ecc4218a0fc0aedbaeea79300026ed4c"
    sha256 cellar: :any_skip_relocation, monterey:       "613b8acb18d84dca751ac4ef2a700eb3ff3ae9dd326579fc0a415ed1641850aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd1d0a44cfb2d955efb93a8fa36f478498023c97ec276b88261bcbfa4fa01e04"
  end

  depends_on "go" => :build

  def install
    cd "clientgo" do
      with_env(VERSION: version.to_s, PREFIX: prefix.to_s) do
        system "make", "install", "manpages"
      end
      generate_completions_from_executable(bin"vespa", "completion")
    end
  end

  test do
    ENV["VESPA_CLI_HOME"] = testpath
    assert_match "Vespa CLI version #{version}", shell_output("#{bin}vespa version")
    doc_id = "id:mynamespace:music::a-head-full-of-dreams"
    output = shell_output("#{bin}vespa document get #{doc_id} 2>&1", 1)
    assert_match "Error: deployment not converged", output
    system "#{bin}vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}vespa config get target")
  end
end