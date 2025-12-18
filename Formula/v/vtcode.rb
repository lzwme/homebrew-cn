class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.50.4.crate"
  sha256 "b3ab303c793760004d924ce4a04ad4e9ecd1018b43204f846e1ae08fa8ba53df"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef8340dddd3e93b34a43ad0d0e5a785db39c2215054af9c6fdfd62e52433ecc2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4f038b48c021d85bf4311e959e21d6fe0360a870ed44b3ac1925ce48822aa54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fcf1c6e967d3487d3e0aa4fecd8303582c71d9c8d3401931fc0a613b5087d933"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf333f272638c1f2320449a1a14151688c488ff7c8a2e8edce4ce91c4408a5c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02506aed6f9f431ff47ebd7021b7aee06ca48a68c389f8f4c8c73a1ceff88cda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e490a6a7d4a44d25e1e928c0dc37ae5a58beb1ac27f5068912898decd86195b5"
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