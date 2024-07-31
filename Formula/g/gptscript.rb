class Gptscript < Formula
  desc "Develop LLM Apps in Natural Language"
  homepage "https:gptscript.ai"
  url "https:github.comgptscript-aigptscriptarchiverefstagsv0.9.3.tar.gz"
  sha256 "6fca0239868ff7aa116c89cf77f999af8609d70d115c5885e3cc5ce4014ceafd"
  license "Apache-2.0"
  head "https:github.comgptscript-aigptscript.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d147d6da9a257756b6a28fb6007e1f87903cafddfd19833f3f2d77feb9ad3721"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25b37ea861d6a632e6e6996346246d5e2b8b024b65c732ccdfb0df7d2081e019"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f62909c3a30c3ad22156b603477e0c20470ee51a0a2d35c47b03a0613cad94b9"
    sha256 cellar: :any_skip_relocation, sonoma:         "45512665d8803e02976a727755ffd35ed153f8dbef286da7ea18c66691ddccaa"
    sha256 cellar: :any_skip_relocation, ventura:        "3ff57695b7188b8577523cef601e87fb86715760014b995fef0008f7a125c91c"
    sha256 cellar: :any_skip_relocation, monterey:       "719063956f81fa0a951a8607fdc341000da9384777d3359b1041d08be816e333"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23b121bdacca156613ac948177ab69631e406eb8c3b8ee753d601624eec834a4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comgptscript-aigptscriptpkgversion.Tag=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    pkgshare.install "examples"
    generate_completions_from_executable(bin"gptscript", "completion")
  end

  test do
    ENV["OPENAI_API_KEY"] = "test"
    assert_match version.to_s, shell_output(bin"gptscript -v")

    output = shell_output(bin"gptscript #{pkgshare}examplesbob.gpt 2>&1", 1)
    assert_match "Incorrect API key provided", output
  end
end