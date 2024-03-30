class Gptscript < Formula
  desc "Develop LLM Apps in Natural Language"
  homepage "https:gptscript.ai"
  url "https:github.comgptscript-aigptscriptarchiverefstagsv0.3.0.tar.gz"
  sha256 "b521ff8c980587642e486db390732bb8fd5add47906c3622719aad36ee78d218"
  license "Apache-2.0"
  head "https:github.comgptscript-aigptscript.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "33b2d1671327746a6775f9518f14c2c6083a02da23832c8e1cb91830b028eabf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7280e821777dbeb06216c59c2c03ed7de7d6be13a8d0824d8fc2d5a3427abee5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4dac3933c9a14cf3abcf2788928b2517d05dcd9213556f199cdacddc4ddbadfd"
    sha256 cellar: :any_skip_relocation, sonoma:         "f4a07007bf4791225daf8d398254f8aa455389678b65528a79ebe1ac10ba31af"
    sha256 cellar: :any_skip_relocation, ventura:        "1863d4af489cbcb8fd421fd157e87f0a8560c2faa2dbd1c9bb3fb1f24e8e2f04"
    sha256 cellar: :any_skip_relocation, monterey:       "7bd4e848d0dd41975d7d65c1c5852658e6cdb0b468bf355649ba737a082bdc11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c83468d730520d1b4dc692e1b48488efbe37c29c4352aab0d272fa9d76dad35"
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