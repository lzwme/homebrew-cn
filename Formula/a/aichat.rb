class Aichat < Formula
  desc "All-in-one AI-Powered CLI Chat & Copilot"
  homepage "https:github.comsigodenaichat"
  url "https:github.comsigodenaichatarchiverefstagsv0.28.0.tar.gz"
  sha256 "c7a47548eadd59206e3ba67e5c0219dea9b76042d057032487f9a9c0a4133cba"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comsigodenaichat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4467895c85b08e7b0dd315e111680c26cc5ae7e5e86799c9a3b1d543e1b0c867"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ba21046550311682a10c55e9cf5adccf92c1f50036c9a415abe293eee4d7508"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1197a6f56d8524fb9feb264500f774b4a8b7626bb59a3af8d58aa87720561057"
    sha256 cellar: :any_skip_relocation, sonoma:        "971b428cc5d99dd027ecffc35656e6e245f1421af8464a0c8c65b2686c64fb3e"
    sha256 cellar: :any_skip_relocation, ventura:       "f4039f859b1d2fa696454e8290b55975dced883c2ae89b6fbaf6ca9d49ff3356"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8fe1c48cff01628a32728d53e477890bec6b7e6fdcfb5219491ed2d5125c8822"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "531fe5d499465153991028824f05e56fdb91e9106e71546983cae38b220a4901"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    bash_completion.install "scriptscompletionsaichat.bash" => "aichat"
    fish_completion.install "scriptscompletionsaichat.fish"
    zsh_completion.install "scriptscompletionsaichat.zsh" => "_aichat"
  end

  test do
    ENV["AICHAT_PLATFORM"] = "openai"
    ENV["OPENAI_API_KEY"] = "sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    output = shell_output("#{bin}aichat --dry-run math 3.2x4.8")
    assert_match "math 3.2x4.8", output
  end
end