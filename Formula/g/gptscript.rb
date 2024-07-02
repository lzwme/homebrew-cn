class Gptscript < Formula
  desc "Develop LLM Apps in Natural Language"
  homepage "https:gptscript.ai"
  url "https:github.comgptscript-aigptscriptarchiverefstagsv0.9.1.tar.gz"
  sha256 "6b8250dbc5887585aadc8762d39d23af1cc15bae77a56863117e14d7bd869026"
  license "Apache-2.0"
  head "https:github.comgptscript-aigptscript.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "878c8cf44d50c5cd317ff255127100a4594599fcf4c89ab0801a428681400ea6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b929943fb1c847074244aab67ea771959585b9d6e2fcf1427a2c3040a70cf9ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "efb80000215d7ee9f090a8399bb5f7e9c8ddc474c8be1af4c229f5c00d6b12f0"
    sha256 cellar: :any_skip_relocation, sonoma:         "ff7e324da31af794ea34c40ab28ec3bfeca21b619ea9ac28f00fb690409fab1e"
    sha256 cellar: :any_skip_relocation, ventura:        "24e3e8b2e917277f003c1733b0d45f967c13c8553641274d9acc13ddf4ef315f"
    sha256 cellar: :any_skip_relocation, monterey:       "b395dc03a197ccf23824f24c11dccd8af18fbef1c5e628dbed609a4ac9baa056"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62d9a122ff0acda4d9337960fc296f9097765317de112b53ef010b7e4cc40213"
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