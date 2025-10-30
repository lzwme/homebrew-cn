class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.37.0.crate"
  sha256 "20008d569e11ad0db863913250da8d5d4c52df8d8a25056951f30eb0927be612"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e4d9e8373b6d9fd5cf6a64540810b9fee298eaff32dd6e59d03b54f0a378c28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6cad844fb4e98bd0222ac643fa516f2a2f789cd0fb369a24a93228693673795b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03045be19636cd3e1ba663d0f3ed9c89620d0b321bc915235c3c693bc3762cef"
    sha256 cellar: :any_skip_relocation, sonoma:        "2840351f1ae47d46bd0f573821bf64483f620b94b18a9a1cd9dfd3c2606cfd15"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "411b583b1572454e2d080183554de6e8a7e121322390c1174637df48ebf4b8b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0164d5ddcb94c94f7a2bf37fabf8d5836ae0f5dcd04db1a690208bc9fb5de566"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

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