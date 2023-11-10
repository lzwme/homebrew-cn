class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghproxy.com/https://github.com/vespa-engine/vespa/archive/refs/tags/v8.255.38.tar.gz"
  sha256 "655cf585b70dde9cae1195c98798ab4678c33c00c5bc33c488b2547a2e097fe8"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8ca27b79a7e2cc367f60f73c65541dbd97acf6e77435964dfbd494f8ee07bcfd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a63dcbb31bf0fe79c38ef112845890fa59732117631719696922d8295d0647b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc89996c95e033dbb685c0dd29c275d3b8acc4fb842137175fcdc24c80e3a72f"
    sha256 cellar: :any_skip_relocation, sonoma:         "acb3f3deb0bc01bd426bfd832b54cda0820082e9ab8e2dd5cd7959a066f07dda"
    sha256 cellar: :any_skip_relocation, ventura:        "c1b9e0545bb2a87941ddf5b54d0740837151fd5cdc85793257aee094038dbce5"
    sha256 cellar: :any_skip_relocation, monterey:       "35e1ed05aa1d215a3153eb29f6f75b0dffc4d885d0b19341e771f9c13e44dd88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a54cd9a19a7a8add7b2662cb128d5d45ab51b14fc2124b30b255d681a089297c"
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
    system "#{bin}/vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end