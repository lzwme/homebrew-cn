class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.136.5.crate"
  sha256 "99081059e8cdc7999c2b3ae93380721fa4c96fcc387f680969e99128da968a3a"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03106c273aca039d7589762e055917b78af31d88abc094ed8b467b30e68b5dc8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0949d7b60a5085ecb5e2b811a077d5827acea20c304dd7f76d6ba15aabb81cf6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b92c788857fd30e0bac666abc865f9b6a3263d93ffcc7a4fa041d31ba22be2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b311a7c16ec013bdce93923eee43908133cf8ad728032f21c7770afadf539739"
    sha256 cellar: :any,                 arm64_linux:   "08fef748f3e98e2d0fa2e4d472983980e83b57a091b5fe9b1aaed2ad9a84449f"
    sha256 cellar: :any,                 x86_64_linux:  "23eed8b236483bd2a86745c47deb773368ca0c1694c1f6ead6553418d9878fb3"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ripgrep"

  on_linux do
    depends_on "openssl@4" => :build
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4") if OS.linux?
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    ENV["OPENAI_API_KEY"] = "test"
    output = shell_output("#{bin}/vtcode models list --provider openai")
    assert_match "OPENAI", output
  end
end