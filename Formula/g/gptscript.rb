class Gptscript < Formula
  desc "Develop LLM Apps in Natural Language"
  homepage "https:gptscript.ai"
  url "https:github.comgptscript-aigptscriptarchiverefstagsv0.8.5.tar.gz"
  sha256 "1c814b7899d10fcfa0418d13bb86967f8fac0b457d14a26ba54469390d12cc8d"
  license "Apache-2.0"
  head "https:github.comgptscript-aigptscript.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a060e0839d3d6b215483d17dc73121e530914c19ffa2e8e5cbce66c724dcb8ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "746fd5415d8c2fcc58c619c76cabedb2cfd504ec1c874da0ad8c54190d050822"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d039c5a8e33bf30c8b78749a5a30f7f2ce461cd292a5430bc7b0affbe6dafc10"
    sha256 cellar: :any_skip_relocation, sonoma:         "f6fadae61a07de0c5f0881906b528932f04ac78c8d153854d5ee65ea3f5c0524"
    sha256 cellar: :any_skip_relocation, ventura:        "825e81e46aa59f1dd8257597bd481de2a25699cbb5b14f5deecfa41616194c07"
    sha256 cellar: :any_skip_relocation, monterey:       "c85dd931bda22247ca65562ba097131c035cf16edd29e73b684c9ad0f79a8422"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd15afbe40c2018968a2943675c9d88162062bcd11a49ede2e7bb1eb5eb4c24e"
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