class Chdig < Formula
  desc "Dig into ClickHouse with TUI interface"
  homepage "https://github.com/azat/chdig"
  url "https://ghfast.top/https://github.com/azat/chdig/archive/refs/tags/v25.7.1.tar.gz"
  sha256 "48331a8b65afc134fd95ead903acf5c05ccb2649fed03e02a731132c4aa472cf"
  license "MIT"
  head "https://github.com/azat/chdig.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4bb30ed9a908377dc49a23d8b9986062722f2f1d8d91025e2203feb347e86190"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ad303177c8922441ca958c1285f394b1f644d549d01cbfb797493558d858118"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d8b1040e87454874c21bf6ee68ccd58a0a806c0bf2fd6c09f72b1a26b341597d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9cb3a34e995a03ab41d296cbbb188e9722505819a6a87fcf541cff34801a423"
    sha256 cellar: :any_skip_relocation, ventura:       "e77432acb9fd7df6ff1e30bb16562118a9fe3f9e06494f8f61ae8362f884cb5f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e631078690e78e6fced0edc7de72299996019fd0233ff4b11db3640ec4b116e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a95ab36016e272ef2cf96ae1f08aeff0d507821601e15a054385a3b4a4831e5e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"chdig", "--completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chdig --version")

    # failed with Linux CI, `No such device or address (os error 6)`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    output = shell_output("#{bin}/chdig --url 255.255.255.255 dictionaries 2>&1", 1)
    assert_match "Error: Cannot connect to ClickHouse", output
  end
end