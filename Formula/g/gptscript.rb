class Gptscript < Formula
  desc "Develop LLM Apps in Natural Language"
  homepage "https:gptscript.ai"
  url "https:github.comgptscript-aigptscriptarchiverefstagsv0.7.1.tar.gz"
  sha256 "88d8660e6b504113ca80aee73581a2e429f70245897913ff254801c3cebeb812"
  license "Apache-2.0"
  head "https:github.comgptscript-aigptscript.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "119280a1608bd5841c8a71d95d4a983dcce728983ca55f0e3bdcdeed1fa77711"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "510d655c0a2153a824fa095c7f85f115106a4338c9bf24abe52b7d4735aa6f1f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe9bf9b6ec6c69377ff95d041d4def5f07b35721d092d32cb32ba685d4b9105e"
    sha256 cellar: :any_skip_relocation, sonoma:         "e35a14c8228c9c02a2aa74ad379c4bfc09425048fce6c4c795feec0577ca7586"
    sha256 cellar: :any_skip_relocation, ventura:        "cfd5eae6aefb5c58fbff18265f4bbcaced2ab20ad5acbe5811f044b9d323272b"
    sha256 cellar: :any_skip_relocation, monterey:       "96f3f5b4aae69b41d3f16fd8ad58e724790e25fd6c1313b3d8a4b590c68990ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e68abdaef14c7785abd87c77b4350d77d7443c0ee7139324d86067147aa873a6"
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