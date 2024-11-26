class Aichat < Formula
  desc "All-in-one AI-Powered CLI Chat & Copilot"
  homepage "https:github.comsigodenaichat"
  url "https:github.comsigodenaichatarchiverefstagsv0.24.0.tar.gz"
  sha256 "a7ec96bb2e7fd84f19447d252949ee9baf8326ee37c06f3149a4b6a189c4e7f8"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comsigodenaichat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b10f5b2dae4a983f109038865a94957d8c84ab2da6a294ddd3310743c99c85e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c37875b086b5f92ac40022b24379a507419e6d5453ae0af64406dcfe7cb66cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d9f5f3f71179b36292e45c30bf28805b1524a00a0310057499ea24a5f63b52eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf8ebb762f05d0c7bae1ddb56581158173f56971ee56fa59538451d878a8b14c"
    sha256 cellar: :any_skip_relocation, ventura:       "3ecba704b8a0d3b7a120d803704735194f80ecd5309ed87e7b62921c5845bd8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "441027de781e7a495f8077e26b3e24c87634e47b6c56c56f7c197f3ba180709d"
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