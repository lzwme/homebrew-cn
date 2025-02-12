class Comrak < Formula
  desc "CommonMark + GFM compatible Markdown parser and renderer"
  homepage "https:github.comkivikakkcomrak"
  url "https:github.comkivikakkcomrakarchiverefstagsv0.35.0.tar.gz"
  sha256 "64dc51f2adbf3761548d9f3ab608de874db14d723e8ca6f9fbd88ebf3bff3046"
  license "BSD-2-Clause"
  head "https:github.comkivikakkcomrak.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3452b00cb548122e85e7a687ffde8de953486e12a143f752dd900bc4a0fbb2d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2469b2f806efb35c6c5424e9dda06f7e6f7f2b2924b3e3996503016b28abde8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "14a0fd6da68a832a0f5102dba679bb44e930c415c152d7a7efe0a868bf69a792"
    sha256 cellar: :any_skip_relocation, sonoma:        "52b2f6f0364fd8542b5b0d429158e534c15a10d35523ca0cbe73c694681dca85"
    sha256 cellar: :any_skip_relocation, ventura:       "085d626d2f40cbf51556c200669e75657a639855fcf2757d6f472c93dd74f891"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f22f5a32c1b8c159a56dc3faeefada0b3ea785408ed6ba642a0a611c5e86dbf"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}comrak --version")

    (testpath"test.md").write <<~MARKDOWN
      # Hello, World!

      This is a test of the **comrak** Markdown parser.
    MARKDOWN

    output = shell_output("#{bin}comrak test.md")
    assert_match "<h1>Hello, World!<h1>", output
    assert_match "<p>This is a test of the <strong>comrak<strong> Markdown parser.<p>", output
  end
end