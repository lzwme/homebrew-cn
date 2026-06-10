class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghfast.top/https://github.com/vespa-engine/vespa/archive/refs/tags/v8.703.17.tar.gz"
  sha256 "29d12050a1f1827e3953109ad9e96001aac40339a26299d094b6a8178ad4e3d0"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ca1c633baaa2161a40374a415ee408fee585d59414d9e1cfdd571a0586743c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d0bc5a7232d4a62257335786498222f3d1973af90476b920e6671fe95aa61cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f10206dd51ed7837eb29a67709420eaaa7b1d610811af817b87368379fe1d19c"
    sha256 cellar: :any_skip_relocation, sonoma:        "41262bbdf944f83d03fe686d00696a432a5cb082539de6ec0c509f153b30c132"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0460f47bc7b122cb4233fc3c037618561cd75e12d081e7d509b25849a6c5337"
    sha256 cellar: :any,                 x86_64_linux:  "6a52fb84740a7c645a1d47c6064e14d7fe5b585028d21acea00115d074aeb366"
  end

  depends_on "go" => :build

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s, PREFIX: prefix.to_s) do
        system "make", "install", "manpages"
      end
      generate_completions_from_executable(bin/"vespa", shell_parameter_format: :cobra)
    end
  end

  test do
    ENV["VESPA_CLI_HOME"] = testpath
    assert_match "Vespa CLI version #{version}", shell_output("#{bin}/vespa version")
    doc_id = "id:mynamespace:music::a-head-full-of-dreams"
    output = shell_output("#{bin}/vespa document get #{doc_id} 2>&1", 1)
    assert_match "Error: deployment not converged", output
    system bin/"vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end