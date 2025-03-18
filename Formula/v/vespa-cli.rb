class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https:vespa.ai"
  url "https:github.comvespa-enginevespaarchiverefstagsv8.497.38.tar.gz"
  sha256 "3d2822fc85c8bb594055250d044a89d0f0c1e8c85164505ad52b0adee4773b16"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(\D*?(\d+(?:\.\d+)+)(?:-\d+)?i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d620074756772c0fce84c7813ff570163df51dcec8a026d2fe0ce9f67582494"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25cf0e19aed3df3bcd2b9fa1a094cd87884e77149984d65044532557c5aee36e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1921668cffbf8e06140ad194e816180abf311b71f696f73db1e681fe099fe742"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5db8b2a81ca2a373ba95c6d35df8333a31126e257f5eb320ddbf0cde86f5f0a"
    sha256 cellar: :any_skip_relocation, ventura:       "f8a1f7cdf125b045dbd136ccdc3541e9dee34ae2530da329ee04eb0f5ce98dab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "963f4013c09bbcfba7861fc1c8540ae96df4ed4c6cf47753d6a5b87f750dc125"
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