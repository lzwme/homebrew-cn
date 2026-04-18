class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://static.crates.io/crates/llmfit/llmfit-0.9.9.crate"
  sha256 "dc84e46c6c9e25e04767fbc7cf06410a745f1dfda4241c59ac9e03ab52d15109"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83c819d30b0a21c24caf2199a19bded5b7f75f04025789968c35660d5715b95a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad8a1200135f5be4f51d57dbd3a5466f3a271db994e6542dbc8c275c22248ed6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0d7b979fa6a211c225de9463513e3c6d4ef995dc742a9a46cb02293faaab412"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7c10670663e75f0bc493259f954c27e9df3413ea7c0f87f3f3a1341af7cb54a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c57bb81366f937d449df99a6bbaa5e1d9c893db446376f00d3aabb2e96b9a7bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d3113e97c4a2b01500e3e004d2a97e5a3a70bd5a99e589fd93883015a5bc76a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version")
    assert_match "Multiple models match", shell_output("#{bin}/llmfit info llama")
  end
end