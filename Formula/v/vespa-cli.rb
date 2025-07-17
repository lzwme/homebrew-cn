class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghfast.top/https://github.com/vespa-engine/vespa/archive/refs/tags/v8.550.14.tar.gz"
  sha256 "ac30f2b11979011a6233f083524a90629a70bbabefb80dc378fb07ce1892fb74"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33dc908b47aa1317ef6659207d420ce4a5402d2eb9dbbbe58224894d7e63b96b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf00f96fc68b548186480e197e408d3c2fedf90a5ea280f0f842a0869a8bf611"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1444007d0a20c3d56b100f77a5b8f08aeb676bff0e3f10c0ff16c10f15c52729"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2368d09536c1b59f98652a9d39043e7af9a1d800a87e5440716468746b482b4"
    sha256 cellar: :any_skip_relocation, ventura:       "2fe80d6135e4e0b5d712a5c1f7fe45452397f50bf86a691750adbc76ade43a8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "729dce37e2c4580def367377b35da7d4178e740a067efca16dadf51a1db535ff"
  end

  depends_on "go" => :build

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s, PREFIX: prefix.to_s) do
        system "make", "install", "manpages"
      end
      generate_completions_from_executable(bin/"vespa", "completion")
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