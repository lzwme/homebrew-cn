class Comrak < Formula
  desc "CommonMark + GFM compatible Markdown parser and renderer"
  homepage "https:github.comkivikakkcomrak"
  url "https:github.comkivikakkcomrakarchiverefstagsv0.37.0.tar.gz"
  sha256 "b4b693e87373b9976818312e87ce8e7e259ce5eceb8e25a2ba4c9f6b3eb3d0a0"
  license "BSD-2-Clause"
  head "https:github.comkivikakkcomrak.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36bfd9d7f21484fddd71056da9831c37a14e81f04c0cb395a9f21a3b889a89f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "241d9869f7d798304ce0055643614364cc2c677d75a58aa99a6d0df1185beaef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "758a0dc0c19efd327493dc09502f9177199039bcf13be1c65322349b8514af46"
    sha256 cellar: :any_skip_relocation, sonoma:        "16bfa4a999085ed2370085d0be58ee9f49a8c0df9e70bdee66841310416b4cec"
    sha256 cellar: :any_skip_relocation, ventura:       "fa7fab1654cba2406c5033d94c66c6b2779ee520488439dc90cfdb50237bc61f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d631ad794f05f433e2160ddc59fd75c5f95c8aa049496e6fe98780c174017c52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f1642d537bfc1838a379ffbe6c01a0aa09b8474b5662cc27a4f5acd9bec78a1"
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