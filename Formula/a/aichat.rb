class Aichat < Formula
  desc "All-in-one AI-Powered CLI Chat & Copilot"
  homepage "https:github.comsigodenaichat"
  url "https:github.comsigodenaichatarchiverefstagsv0.17.0.tar.gz"
  sha256 "113f910315c6fd1bd0746daf346570a26883206d6f61a8a8dd07d98b4c509393"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comsigodenaichat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9bbd141c0e4436ce549f304f670921ec5ae797df1e964deefdda7e1dc6c75a36"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c3e8965114ddeee393357dbb847dcee0b6313dd74b8296ef7b08e9c41d281eb4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e4bd434a906b003ee5b93787556a51b9f975c689b871e8aa5a24ac635d73c2b"
    sha256 cellar: :any_skip_relocation, sonoma:         "e6332b5e0dfbdd8759b4e3b4d0af53fc882b8fe9b77648100a446372c4064c29"
    sha256 cellar: :any_skip_relocation, ventura:        "3d057b697e0495cc007f624a19b992b6071e6d287372af31f2cb0e23c4dfacc8"
    sha256 cellar: :any_skip_relocation, monterey:       "e7ec0ae86080c55503ba30c953593ec3f6aa9f85b504ba0a833cd461cbe5db72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4460e79a37ec6f852c067ea4c595395d24e5383cd8e172592c4253c5a7503805"
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