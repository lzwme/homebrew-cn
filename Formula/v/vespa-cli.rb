class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https:vespa.ai"
  url "https:github.comvespa-enginevespaarchiverefstagsv8.299.14.tar.gz"
  sha256 "dc7648a86abe3e4d77f2256adabf6923e359a2ccede71e6636c1a2a958c0750f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(\D*?(\d+(?:\.\d+)+)(?:-\d+)?i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ba06015c813c8d6853bf5158410d511e2e4c8b13e4d01a792b44f63291d28d3b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "267902b87b526593e38033d004d669a506a0cb627448d25ca9790207ae11828e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5fe557b136b1196805f79bf8171ebde6ce6d1a6c68f2f5874222544d30ee3dd7"
    sha256 cellar: :any_skip_relocation, sonoma:         "13801edfcb1b58742787876fe7828af6985b00e60a4da394c2af1af95e57d649"
    sha256 cellar: :any_skip_relocation, ventura:        "56a9fb6cceb734c5786e679824b03dfa5c924b49112bd070f1263d7af462b051"
    sha256 cellar: :any_skip_relocation, monterey:       "aa4850877f63fe56714acc51e08782637d5ae20cee0361faa85c0374c0ed9096"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e44967829016be87b25f6aba7effb60f67202600f095c140a692f87fba0b82be"
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