class Gptscript < Formula
  desc "Develop LLM Apps in Natural Language"
  homepage "https:gptscript.ai"
  url "https:github.comgptscript-aigptscriptarchiverefstagsv0.8.0.tar.gz"
  sha256 "7c85bc7e6edd835220db7a695fe51176b4dd228e25069ae0aae27af27e8e1174"
  license "Apache-2.0"
  head "https:github.comgptscript-aigptscript.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8060a166676faf1d82c20c23980394237905e61fd078be4dd102b8e39f3b3a2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba7f1b93842f122e87c9037d8a55ffd177024abe8a423cd06cf032394b8d1fc9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c56039cb645e01578fd22e4d00106677670e37e6fa0cf9b311eb8356bc1f4534"
    sha256 cellar: :any_skip_relocation, sonoma:         "9265f66308812ab8e70720f104d6910507cd2c57b64b3f81aee48ea3c6bcf407"
    sha256 cellar: :any_skip_relocation, ventura:        "029c8f0060f741352f8b5db50b03d27e972055b77a80c8e5c272fbf9c4df21b5"
    sha256 cellar: :any_skip_relocation, monterey:       "9f33c4bba54eae59c6b12c9cbe8b69b3ddf283830a0a6d4a8e4f6d9f549de95a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d68b74928530b08a2c9cd3a7471165030cf7fbfe2a9a6d89eae3771d5dfa130"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comgptscript-aigptscriptpkgversion.Tag=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    pkgshare.install "examples"
  end

  test do
    ENV["OPENAI_API_KEY"] = "test"
    assert_match version.to_s, shell_output(bin"gptscript -v")

    output = shell_output(bin"gptscript #{pkgshare}examplesbob.gpt 2>&1", 1)
    assert_match "Incorrect API key provided", output
  end
end