class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https:vespa.ai"
  url "https:github.comvespa-enginevespaarchiverefstagsv8.293.15.tar.gz"
  sha256 "7339329b191ac36ca426729d2145a3847b856bd675d1019ddd0bc95b8a81304b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(\D*?(\d+(?:\.\d+)+)(?:-\d+)?i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c79ba48afb0996d3abaf56b0ab453ae9c89127240e46bed0004cf4cdee9acf7c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b35136c208cee8291b9aeff1b73bc9d52d3c7b4cdbefa7f0c6a8a84c579b9585"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ab49897231d3d6aa1a2292fd20165be83838a3ee0894afb41997f9c7837f6d0"
    sha256 cellar: :any_skip_relocation, sonoma:         "2311d5426acd64728285c29b0c437a7bfd2c4e0d7e38d752d97159ea6766aef5"
    sha256 cellar: :any_skip_relocation, ventura:        "19220a3ab48aa7394cf1d9103498dd096c0a3655466eed72205cfe7c8f19ab88"
    sha256 cellar: :any_skip_relocation, monterey:       "05c680db074ebf99018ac2932f8b4e7e29cdeac2ac953ef7f76b924d0b173df4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa738434bf4e51a62ad5f0ded8bd618792cd29bc928991a8cdbf1baccb5fe059"
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