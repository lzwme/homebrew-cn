class Aichat < Formula
  desc "ChatGPT cli"
  homepage "https://github.com/sigoden/aichat"
  url "https://ghproxy.com/https://github.com/sigoden/aichat/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "63ec9b08b2ce3fad0baae256aa77fcd6612afb061d10da8d96af2d3a013dc3b2"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sigoden/aichat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e9384ead441cb772816a447745e71936838c45e2018ee6e508e6e8f6821fdf15"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7c4d37b7168a90b373fe42f51013b743d9ffbd29e1daef20ca85742bf1d733f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77dca5268f19f9d4bdfd93a8e4649adf0e52827c2fb7108ba9fb33f2fbd4f18e"
    sha256 cellar: :any_skip_relocation, sonoma:         "9aa2f148903a8685bac08259d15efa8256fdc46c9138e5c723666a380c5fc68c"
    sha256 cellar: :any_skip_relocation, ventura:        "e85f5bd2126585088bd7908b0e8d7b8d3b4e11e2e82e4dc2ceb8737bfa4fb846"
    sha256 cellar: :any_skip_relocation, monterey:       "466e9555f46006e0bf49f2e0ef908f6c7a9a921092a58d7e4fe85ae16da84e87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd29397b0dfcb9d55a5f609fbfee843ec8e1551123efbf83033f010f21565ba1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["OPENAI_API_KEY"] = "sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    output = shell_output("#{bin}/aichat --dry-run math 3.2x4.8")
    assert_match "math 3.2x4.8", output
  end
end