class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://ghfast.top/https://github.com/AlexsJones/llmfit/archive/refs/tags/v0.4.7.tar.gz"
  sha256 "95085ccdc7cdb27e0e23e8132922eaf9ba16916c532884d3a21884e53d1bc161"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30b55a801a6723c7f0d6362d46c99a57dbefb61f9cccf875a8c1e38a9f6f1fe1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "116f4e1934a57bbcf4947cabac184540f86dd92d1139d245adafbc3f4bff3410"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "273a034043ce48781aac307a5fc004e14e810ca6f9009de777f12de08a23113e"
    sha256 cellar: :any_skip_relocation, sonoma:        "7da62a0c95d64b4e04f16b5917ed0a25808deb079cf20983dc397ecdf6c1c286"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b0395cc41e3c0ee18f993e4ea8f06a1899338fe89c91a82bc0a3f6532ddaa5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb002b3e8463c8e4068bae2b91cf3b03e6da9ca39db82e61382b6a5608ed3137"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "llmfit-tui")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version")
    assert_match "Multiple models found", shell_output("#{bin}/llmfit info llama")
  end
end