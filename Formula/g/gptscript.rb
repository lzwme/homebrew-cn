class Gptscript < Formula
  desc "Develop LLM Apps in Natural Language"
  homepage "https:gptscript.ai"
  url "https:github.comgptscript-aigptscriptarchiverefstagsv0.7.0.tar.gz"
  sha256 "77df7658585b634778382c5c472e082ea66ec40c574af1314d79d080bafbd98a"
  license "Apache-2.0"
  head "https:github.comgptscript-aigptscript.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1301675aeca6ab3696343399ff3868cd49971a4dd516ddac2babcac1d810e275"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f745145a130b0a2cab55a4615fc02edb5f340fe89dd618c2d34aebfd02cc81a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e096c4ecdccb2461883db399068949ca8546ea6866ddf46c659eae8ef92b6e1"
    sha256 cellar: :any_skip_relocation, sonoma:         "59ca18bc0ed9398d24220e57a93f2362648b3405da7da865dbcdfa94c84ebdbe"
    sha256 cellar: :any_skip_relocation, ventura:        "76098b6b7cebdb77fd6cc2eab24d81d3c9b46f3884e5251f8d7d443554c387e0"
    sha256 cellar: :any_skip_relocation, monterey:       "d2c0c9ac4ca67d23558a4ce8537c74eafaf3ab0f43bf168808c140ad0162124b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b82db2d4d2878edff6c4750bb237dd16f63f1c0bb689a84a6c740c292c32e1b3"
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