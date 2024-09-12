class Aichat < Formula
  desc "All-in-one AI-Powered CLI Chat & Copilot"
  homepage "https:github.comsigodenaichat"
  url "https:github.comsigodenaichatarchiverefstagsv0.21.1.tar.gz"
  sha256 "4045c89bd94809969cc15d29889f0d4e662d2c68b129b9cda66eebc738c8016a"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comsigodenaichat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7f98d8c44a90d0d5df139b386849baf0a63afa8e56f0c36ac1256d64ad63149a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "26d187f8f22aee1d7da73ea159d6f0ac18a472b5a3ced39f3b9f6baab29baad4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a8511c8b74891733d4e57b1909b6b2ff1f1a59c61f2a9574921bbd6b9ad8dd5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "020d3e00a0a2350697afd45d0db4434b50534d627b8583b15344c1e7b29f7a9b"
    sha256 cellar: :any_skip_relocation, sonoma:         "3ad09fc462d344008bd35951740c05c0845967661f4d25ae46d299633350add7"
    sha256 cellar: :any_skip_relocation, ventura:        "17951cfbbcf6d58d1e2ff9e6df9250040dae7aa2dd341e1e2e436cfd248f0a93"
    sha256 cellar: :any_skip_relocation, monterey:       "680df66cf5a5f86a209af2edac73e9bcf5bd75ff86b485c366c9947778902cf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "803b31ce60426ef40c0b2a90c766e3fad91d920b239a201ba063c580f24de672"
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