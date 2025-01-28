class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https:vespa.ai"
  url "https:github.comvespa-enginevespaarchiverefstagsv8.470.28.tar.gz"
  sha256 "fcb9da8b3152f8048e7fd6dbe006ffc85cdfbcd45a4482bd73e88607f139ce1d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(\D*?(\d+(?:\.\d+)+)(?:-\d+)?i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d67528d60771d6366d20cdc47de9ac6914ae6ba194ab53606bd45b49054085e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4007849a33aab8057cbe6be11c56f15953a33d04e4b3f611c164a9868ef9311c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "498aecf0958b08ebf1792eff88b390bf83baa3ae029fa718b625b2542de38579"
    sha256 cellar: :any_skip_relocation, sonoma:        "99267b9c9ba033b1ebb741b2fe968e2a952335ad88e9388622bac6653a8d6a8b"
    sha256 cellar: :any_skip_relocation, ventura:       "1e77967e2977c3120582fbdb520a38652ea898d6314ca1a7f4650f0def52c6c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74c1e34a47dae03ab383fb164e5e5fd93fcafc425530b030a42752e8f47d0fd1"
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