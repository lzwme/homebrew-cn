class Aichat < Formula
  desc "All-in-one AI-Powered CLI Chat & Copilot"
  homepage "https:github.comsigodenaichat"
  url "https:github.comsigodenaichatarchiverefstagsv0.25.0.tar.gz"
  sha256 "2d67b99891cb5ad2754a4ae76785796ffa86aeb83d6ca9da87f14feb43fcf0ad"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comsigodenaichat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b2a8a83e40d44b203b297e2380d1e6e54b6a6396a0da4851d940b4dbc55e10c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc49f44df44f54c25bfed1bb0e37b51f85005384a5f78bc21e2df7ecdfd81cc3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fafb98c51eb42d5f0ec2fef0c662ea476f7983af5b590ee933de212ba8d157ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "132724413dedd6ee94c58f861f732b24e09fc363fa8f08b1e863c03d046bf93f"
    sha256 cellar: :any_skip_relocation, ventura:       "47214c99166965ad125c8f7f5ad19ec4d11a917360ce7e4df83e627577069a0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bda524239c749bc56576c3139ef12b9a2f6a13718f25f6efca3cca5239375f0"
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