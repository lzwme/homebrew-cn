class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https:oxc.rs"
  url "https:github.comoxc-projectoxcarchiverefstagsoxlint_v0.16.12.tar.gz"
  sha256 "a8560bd5fbe7f186d340e31dad0c8ba4a976127c6521b92a78a638b9c0745e08"
  license "MIT"
  head "https:github.comoxc-projectoxc.git", branch: "main"

  livecheck do
    url :stable
    regex(^oxlint[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b57509c3df3887abdf662ee37d2bed0de9de9d080c836f4d89ca759e7ff6d661"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9497ec860cebfef845f08898164ffd6998252c61c4d16527d48a693b595b0798"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "651f1e2a045131b46a7d2db40329233d922b9ea130efca9066dc21614c04c895"
    sha256 cellar: :any_skip_relocation, sonoma:        "a026a45c79466c0ec37051fa52864d07bb54ceb5f3b6ee49878e058326bacb66"
    sha256 cellar: :any_skip_relocation, ventura:       "3b5bd19d466da82a66a1d2f76fc66d55afff942f05df254003f4dc3726c9472f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bfb494038aec1cdebc7fa258c78a195aaefcb5d86b12302931c6f4d3b03937d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "680dce24aa25b48273b4815089ac5bd9398ceb6740ffb6edd8826f6d1e937578"
  end

  depends_on "rust" => :build

  def install
    ENV["OXC_VERSION"] = version.to_s
    system "cargo", "install", *std_cargo_args(path: "appsoxlint")
  end

  test do
    (testpath"test.js").write "const x = 1;"
    output = shell_output("#{bin}oxlint test.js 2>&1")
    assert_match "eslint(no-unused-vars): Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}oxlint --version")
  end
end