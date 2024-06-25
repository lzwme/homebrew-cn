class Gptscript < Formula
  desc "Develop LLM Apps in Natural Language"
  homepage "https:gptscript.ai"
  url "https:github.comgptscript-aigptscriptarchiverefstagsv0.8.4.tar.gz"
  sha256 "f13e52415bf4f49dd489231675a1dceb78068de486009400c96b717e89d8e804"
  license "Apache-2.0"
  head "https:github.comgptscript-aigptscript.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5978c7215d584df9b8d3622dd6799bd0e44703d6fd4cda88f99d127432bbc1c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6bd57b201b042e30a02eabb0c05f2962088d5a36e0ea7167d3f7058f7f245d0c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb47b186d6dddba3379f5dd82b319e57c1983d1bff18d7e0bc2a2464c3e593c9"
    sha256 cellar: :any_skip_relocation, sonoma:         "094e844ab87bbfda356ee78059a9d3c7ff55ff2812a42af86b29b9126c8cc05b"
    sha256 cellar: :any_skip_relocation, ventura:        "e4f5e9d6e789dc273a463941beb87e2c205abad39cb8e6faae30dc0230ebeda8"
    sha256 cellar: :any_skip_relocation, monterey:       "9ae073ebe554e215aab81f52b367dd4eb23c3a1270e3441111b53a984902e06e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11ed60051718546820273e8a65ab51b5da9919648a2bc5b97afc467b53aa0fa9"
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