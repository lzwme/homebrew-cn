class Aichat < Formula
  desc "ChatGPT cli"
  homepage "https://github.com/sigoden/aichat"
  url "https://ghproxy.com/https://github.com/sigoden/aichat/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "d55ac87b587a25acd0203a2c310250d66347b6733e33f7c4f7546b17d1a3ebe9"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sigoden/aichat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6983269fbf768efa1a1a0f55959be062a6453238942a53c975847865ff1084a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5b704396108873808e0df83835b392b0a171e92f150f4391af5a4113b564d54d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9529d8026947aba89bd32d563537328d7b83d5655848f48fe8c450f372ec6ebd"
    sha256 cellar: :any_skip_relocation, sonoma:         "3fd14f49dcf935f2c8ee62606732f88e8b89c43bedeffec68ed83e1dc534d595"
    sha256 cellar: :any_skip_relocation, ventura:        "5731aec7a183779c74f4832f8c5d497425ce82813cfb2cbccf2fe0d495d271d4"
    sha256 cellar: :any_skip_relocation, monterey:       "2ef2852b2ae527eecdc73024558cce52955c2826cbda866c614eabd77ebbdc81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a62d24c88df1a5f9fccb7b17955c8686c1735077201551cdd8ed98852bdb8f4a"
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