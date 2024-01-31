class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https:vespa.ai"
  url "https:github.comvespa-enginevespaarchiverefstagsv8.294.50.tar.gz"
  sha256 "e5f90288ffeb2e9bcfacecb8347ba71b55f67003623d790e8e4e7fae0203b0d7"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(\D*?(\d+(?:\.\d+)+)(?:-\d+)?i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "75bf4aead1ecd0cd5011d80472ce52d6bf2fbe5ea0288665127ac3c5acaa9212"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3099703637f8f756539f5a4d32cce86d2fa536b7ba252158d0ec15b90f572f85"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aedd52a936ed7b290bf857c2bccaa8d41741b4d8638f2a5d45a5a5d6e86b6c02"
    sha256 cellar: :any_skip_relocation, sonoma:         "8401b637f24a575bb57a22a0d284f618ee9c4ecabc6ca8678920d80683ff1430"
    sha256 cellar: :any_skip_relocation, ventura:        "3ff72eae5ff0468b3dca423cb095b5f1cf671391faf726f7505ed3b6c2723b32"
    sha256 cellar: :any_skip_relocation, monterey:       "8a032d7e147f00666b8782c4d60a8b20380b40a5395978fc8f4c06d12ca793dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2553cd49938851345fb65c7cf12bb4d68f1e8b36f0e9f14603c8a24ea3717d78"
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