class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https:vespa.ai"
  url "https:github.comvespa-enginevespaarchiverefstagsv8.448.13.tar.gz"
  sha256 "adb2cfef021799873268d962364b282eb4cab772a1a3bbf8fee9f649e62df16a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(\D*?(\d+(?:\.\d+)+)(?:-\d+)?i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e76547dd0644e8fed2b301da4d0d26921d802fb72dcf5ad787b4c2550125fc5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d49a9de875f5ce5ab204721fa5a4e07018511d5c8f45128d312582968489de6f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2ad688648e48d419337e57075ecf733f48cf11e70fdf89eace25e30322d08c0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "e967e66523f6b91e7777b5443e37749e94fb11c52ba90d210a5bae310cdbdf77"
    sha256 cellar: :any_skip_relocation, ventura:       "20e60dba76e905d5dfb30838a845aeab4eabfcf2b491d7c4127f1df54af8f01c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b532e472411ab62e84b45bba1670f58b4c1511e865b0cba1d2359cdbd7c83a7"
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
    system bin"vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}vespa config get target")
  end
end