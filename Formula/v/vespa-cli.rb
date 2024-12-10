class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https:vespa.ai"
  url "https:github.comvespa-enginevespaarchiverefstagsv8.453.24.tar.gz"
  sha256 "f53703c134b90a6b4660baaf0a0018990319e16b890132a4c3145557951f0cf7"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(\D*?(\d+(?:\.\d+)+)(?:-\d+)?i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0972c0c1e631e1c370c287cb025b264edf21287d23d66b3b15f250abf413f0eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fddee1223ad31d4e48629601965b02eb77b6bf1583c79e879f72fd8bc30b4c22"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e19ea0beddb9092e4ee4a843296b9a6f15a2caab24280a82da62db5babf17057"
    sha256 cellar: :any_skip_relocation, sonoma:        "9577f41f9f8e8f636e119ed68a3dd1dd62a51a99b95c4bfbd6edb6f27e0cc814"
    sha256 cellar: :any_skip_relocation, ventura:       "5a68f8c4967c5432e19da675a05ed217e960c6a566b346e6cf489c2496c96eb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9d8bb44bd86f8bfe02afd3718d749790bad852867530cd9a72131ab7ff75422"
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