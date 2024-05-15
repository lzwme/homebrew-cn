class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https:vespa.ai"
  url "https:github.comvespa-enginevespaarchiverefstagsv8.342.20.tar.gz"
  sha256 "fa9c09351b65d3142a7abbe4f2347058427aacce63a9742e83b772b27436d540"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(\D*?(\d+(?:\.\d+)+)(?:-\d+)?i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "472cdb6d5a1845177aa676df9530f76997bb553bf9a285b1c88973de2ba61267"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df8d27e60cd90df69d5fd927258ef0bf3f766d61f2ffb47c7dd45b4930178549"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ac873b20e346d0d4d99848942f338019a2ab31e0a4e33f8d0696483dfcc727e"
    sha256 cellar: :any_skip_relocation, sonoma:         "616f57d0b553ff0a1a15338d9c395b1eda3753509a853ab87d986fe97825d232"
    sha256 cellar: :any_skip_relocation, ventura:        "6739e31e764ca563e30657bea978795e0944835a4a9caf7e8d8ea4a9f81dfbcf"
    sha256 cellar: :any_skip_relocation, monterey:       "075e790f716fa15ea6013748b5fcf4350b2e1dc83aa29eae094b76b2178e9858"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84a81d5e6ed47304b918d3cc61d9936ba46d15e927b540102690b5222547355c"
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