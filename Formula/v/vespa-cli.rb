class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https:vespa.ai"
  url "https:github.comvespa-enginevespaarchiverefstagsv8.485.42.tar.gz"
  sha256 "ed4a37991a8aa2eaf288a51498c83d569575daa1ce5e9826d5ac668a494fa078"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(\D*?(\d+(?:\.\d+)+)(?:-\d+)?i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5480985496f58e6784b52e7d96f5fb50f52f303653f6c4760181095a0ba41a20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24ae2230266a2b993479490f6cec2c52f179b39e1fddf3cc5e621f65108f9dec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cee62b1069f33c84fb588e73cfcdf824da9e5332f77f5226cc0e9c7532ff1a96"
    sha256 cellar: :any_skip_relocation, sonoma:        "7648a4c0add9a394aa565d37d45c459c8398d234750f9007f9e0d2721de0f428"
    sha256 cellar: :any_skip_relocation, ventura:       "73b1ecb2902170f93fa8cc844303320127639e1b035388ba2845af8661b3e393"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "596ea734339b873c03196249327cd68b1735d784f69b6f1873fbfcc82994c8d4"
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