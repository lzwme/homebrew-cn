class Gptscript < Formula
  desc "Develop LLM Apps in Natural Language"
  homepage "https:gptscript.ai"
  url "https:github.comgptscript-aigptscriptarchiverefstagsv0.9.2.tar.gz"
  sha256 "d0eafd87b503a193e47fc0b2fbe926b27fbaa871455ac318da67079f28ffc852"
  license "Apache-2.0"
  head "https:github.comgptscript-aigptscript.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f20814619925f3d18bd3038f0491f777932e31d10b2d4c9bc1697b02b1b64832"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "209c6b5102aaf4a3dcd4457d8b4f4f1b80fab1a2cf68a6bffaa5e81b6d71546f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b61d360e999106875012f79b7723d8382526548be912ff4049950ee4d99e115"
    sha256 cellar: :any_skip_relocation, sonoma:         "3d1d83f617bfb2b313e8d9b3012bedc0f65dbc5676f33e458616babffb1cbb2c"
    sha256 cellar: :any_skip_relocation, ventura:        "cf55cfaca8a5aefeefc69419e5863448e33cd691820328288dfe3513ba877884"
    sha256 cellar: :any_skip_relocation, monterey:       "ada49f51626d59853d30294b76a196da61a2809a4109441acbd5fd879bec4dc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4df089083726e8e81939da0a20b076f6067c28d475af05259bcdcdb49f911de6"
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