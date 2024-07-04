class Aichat < Formula
  desc "All-in-one AI-Powered CLI Chat & Copilot"
  homepage "https:github.comsigodenaichat"
  url "https:github.comsigodenaichatarchiverefstagsv0.19.0.tar.gz"
  sha256 "ad18bcca2264c467c98e3f3fda86c02b140e201e0d253895a23a3ee5e7e1a9ee"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comsigodenaichat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "09425e6b454676341baeedb03c46a59e65f96fad2b16a73d693225090b1f5b98"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ceaaaf8fb4e731a875e62c1eb268c704718a3f1b945b026d50de29c9f42ca527"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8349543e507133bf0b44514fc9b4cf0772dbffef33dbaa42ab5ab81bd70114b1"
    sha256 cellar: :any_skip_relocation, sonoma:         "4fe72542334956b3e127b6d60432cf3db240520aa307208e4a8271c18ec85f5f"
    sha256 cellar: :any_skip_relocation, ventura:        "d98779b5e7bc2623057251ab74f0770ff52554a721476b5f5679f9d51f250765"
    sha256 cellar: :any_skip_relocation, monterey:       "9feb47659a700f5e0713ec1f60e1a2181e59814915eeab59406a37306a8b64a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0173c96ced6e53624a1ce92e24a12d5bf2bf9cd2f1e7d4425bdfd4e0a3499c04"
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