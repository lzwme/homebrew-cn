class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.114.0.crate"
  sha256 "1a61ecaa3123cd65be041b836552ac92b36800a78f02524b719969da6464720e"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f0cf385cf105eab501e2740eb57a262711e70e8c15f08897b16fbe0bdbb721ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5180695fc56e44096438ac904ad8c8a32f895ea00a39bbf985822b64d848b56a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0bbde62b6a0085bec99290023d608e7670fafefbb232195b7492467c6453eca8"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2a48f98b11aa02628c39a8fa2d3983cd46619ef2f27af34516b2f5ed9b94ab7"
    sha256 cellar: :any,                 arm64_linux:   "9b24b758bd98e965e9c481a7dd61cb8cc5e28c3bcc05329863cbc11fb975356a"
    sha256 cellar: :any,                 x86_64_linux:  "8f9af309be67bd1befc8a7d21c5f7235b6d1be3addbaaf07ec9af8a4730a71cb"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ripgrep"

  on_linux do
    depends_on "openssl@4" => :build
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@4"].opt_prefix if OS.linux?
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    ENV["OPENAI_API_KEY"] = "test"
    output = shell_output("#{bin}/vtcode models list --provider openai")
    assert_match "gpt-5", output
  end
end