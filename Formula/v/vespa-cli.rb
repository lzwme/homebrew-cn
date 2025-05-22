class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https:vespa.ai"
  url "https:github.comvespa-enginevespaarchiverefstagsv8.523.24.tar.gz"
  sha256 "d2621fd56d7873a76c7444f45b7779cfc3b13fe4d21fe3fc4998f921360a6aea"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(\D*?(\d+(?:\.\d+)+)(?:-\d+)?i)
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "190d61f4f83f87086d801fa36534ca5e71934024b06bdc8138216532513737b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d482200010b4252acab164d47a55576c263733455070c63c3bcae010f4f6143d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f75f88ec27df4bbba93eff8b5425a1cfcf0b6825fb639a9663539b50e0586be9"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3af2bb95b8583caf6cf1288704ffb1590327a460d77ce1d9f09e5fdc0d11c08"
    sha256 cellar: :any_skip_relocation, ventura:       "e0132d631324c8ebe4e4eeb81e487439a91c017167617a6ddbdbf5263fbf3664"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44e038ccf5789a128935e20168239f8ad7de7a7b2f99fe812383561150d7929d"
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