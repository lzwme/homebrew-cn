class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https:vespa.ai"
  url "https:github.comvespa-enginevespaarchiverefstagsv8.405.15.tar.gz"
  sha256 "0916c0a34d60f8d46c9458b3c2b15ace477d96594ce43e778fc4d98f6387a80c"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(\D*?(\d+(?:\.\d+)+)(?:-\d+)?i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e33c02d877b2d9beb98b0eccc066b59f13bddd816b70a7f0ed80a912d2d60d9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b4e0b53d7bb9abd620782133d495ef5c2c6a4cf306f2bc579a6727f3bcc73b17"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4fb98d8220f65d1f2a4e65145071d59e3ec9a2c7f09d8ff4208775e2b81bf1d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b35de031c86c8a1481c5bca7221e93d7871a46a325a47305246993859984138"
    sha256 cellar: :any_skip_relocation, sonoma:         "7e83652932cf4beb97761fd01d22dbb86da3d99e28c3a5631999e2d74d96ee35"
    sha256 cellar: :any_skip_relocation, ventura:        "75683f2056acc3382f9fc37f860af573722f2a76e738f67f29fd161d088d6531"
    sha256 cellar: :any_skip_relocation, monterey:       "0165915004d0d1a1be006cdc361e5792a6ee95eb74a494a7569018a5c92f00be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fce14905618d60d6b69cb3f78a52fb570b4437fbda6f28adc6c9653a6233e59"
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