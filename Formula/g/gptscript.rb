class Gptscript < Formula
  desc "Develop LLM Apps in Natural Language"
  homepage "https://docs.gptscript.ai/"
  url "https://ghfast.top/https://github.com/gptscript-ai/gptscript/archive/refs/tags/v0.9.8.tar.gz"
  sha256 "13666d4cce007c3da8c1a9afdd6ffa0ae9d584aaa5ca57597caf71c5008d490c"
  license "Apache-2.0"
  head "https://github.com/gptscript-ai/gptscript.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e68bfae17b15309e584e05a2fecf613db2c66b52fd71b31fc1170f48c9023d41"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e68bfae17b15309e584e05a2fecf613db2c66b52fd71b31fc1170f48c9023d41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e68bfae17b15309e584e05a2fecf613db2c66b52fd71b31fc1170f48c9023d41"
    sha256 cellar: :any_skip_relocation, sonoma:        "e930b112405d15a1e6557420d4185c59286ff262e656e8e9bdbbf0a9cf373b80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0fa40d8b022d84ac30f3ecda19cccfb9321a7cbcee8112d699b8f99de81036cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1aa753da115fcb83dc12d015faf64f5ab72de93071e37f9b18864ce00f69d314"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/gptscript-ai/gptscript/pkg/version.Tag=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    pkgshare.install "examples"
    generate_completions_from_executable(bin/"gptscript", "completion")
  end

  test do
    ENV["OPENAI_API_KEY"] = "test"
    assert_match version.to_s, shell_output("#{bin}/gptscript -v")

    output = shell_output("#{bin}/gptscript #{pkgshare}/examples/bob.gpt 2>&1", 1)
    assert_match "Incorrect API key provided", output
  end
end