class Aichat < Formula
  desc "All-in-one AI-Powered CLI Chat & Copilot"
  homepage "https:github.comsigodenaichat"
  url "https:github.comsigodenaichatarchiverefstagsv0.21.0.tar.gz"
  sha256 "1ab8b9c0c352b62be8f4002faaf5f00fe5f7459ac00974066ce801adefc176de"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comsigodenaichat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3c8ba748d0f712f69c238e053ff3e5116c23ed61c19a5adf1ceb80884abaf0b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b589c60299fd044037e7928810c4b62778ad9115f1555a0cb4dcc68f953dc45"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff58411f306216147a43fc82dea08e940b824b64c585acabf0ce0a5bcc99e4c6"
    sha256 cellar: :any_skip_relocation, sonoma:         "1c4e01c64d194bc91d1bbe8b365bee25e6c47278a4403d5c9615486c309aa1f5"
    sha256 cellar: :any_skip_relocation, ventura:        "c46df5f4f99255a28abe9bfe43b3b9acf8af3ae3420dfd7ffcd230c03307b48a"
    sha256 cellar: :any_skip_relocation, monterey:       "04306a3720de9256c26d9a381441f0a6ad3632668c6a72611bb9f1eda15dd742"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfc0ddbb658af9d307e6daaa5f1b4ce4d3eeaecdf9da086b5df7678fb90b4d26"
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