class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https:vespa.ai"
  url "https:github.comvespa-enginevespaarchiverefstagsv8.482.31.tar.gz"
  sha256 "e8f60ec109c1db9f6c520289d961571ba4235e5cb13b89d61a31860c17b81b4e"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(\D*?(\d+(?:\.\d+)+)(?:-\d+)?i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3ebbe290783a7382995dbc4dc95abc8335b0a470029cc390acf710760a74f3f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f610ecbf71556af3ab56993c474bebe08dd68606226a0ae84020e830ef09c9a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9baa954599817b9144d6da63d347954813a2cf4574e86ec03288ff50202c2837"
    sha256 cellar: :any_skip_relocation, sonoma:        "09eb2dd6ca81f25977c3cfb57cc433b6a40ce4b8f7f1dc99d21cb3edcceb2cb2"
    sha256 cellar: :any_skip_relocation, ventura:       "e3db0040fb3785c424bb8af02be12d814a4aff7b41212a12d90abbc60bf4125c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e43bba91b59a9dd6b3aec7ede8f87c93c1a241d74ec9105497d85087934615e"
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