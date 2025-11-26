class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.47.5.crate"
  sha256 "9a3e3b253a6490637b8b5904564a129cefce1b211e4c259c45d0829eb0f25d2a"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0d501cbbe295b62702b0fcaafd9139bd0a71273d6b7d79bb0ef3af3aae60259"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4922bc7a267e7bf9167128b9fc374333c2d68c228ca23823906ce2535511d18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "daf7b4710afa6dc596ec1d219001ab5bbfc0f1eb1fa72e828948c5f2da1b93ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "efc74760e84e3732d6ade273e81420e2435ae513155c961777fd87b0bbae7f67"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "483c52ce004fab70df812932b0bbcc80df1ddfdc18359e30c7cec43fd836d68a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85107c95069cb40fdfdbc48f181f75fec6f482b3eb2e7820520c6b683e8068f0"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    output = shell_output("#{bin}/vtcode init 2>&1", 1)
    assert_match "No API key found for OpenAI provider", output
  end
end