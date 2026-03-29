class Jsongrep < Formula
  desc "Path query language over JSON documents"
  homepage "https://github.com/micahkepe/jsongrep"
  url "https://ghfast.top/https://github.com/micahkepe/jsongrep/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "5c6d42f5a76e880242c42ffad2f078872d5bb7f4a9e98eb3e3bda92089a682b4"
  license "MIT"
  head "https://github.com/micahkepe/jsongrep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aefbed9d4f865d54332f073b4e8514818745bc027cffb1a9c799daabc680b7f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5de1cec33f956a92f569de7eb86ba5c5ba161d0fec83b6d8e110707157204957"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7a6bd3f9d8573ae5831b64ba35225f462bdd4da4ce51e54310b8aa23e202843"
    sha256 cellar: :any_skip_relocation, sonoma:        "f69b942d9a8c7646e2820c74df12765194855e3f07292e98a6180ccf5d4a3006"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a57ad6d876d51e68259d2e97eb3fc5cabd1986e8b1bd126f46092112f59c60cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1362c7ba51cfcc77a9a4f76fa4140bf23e3ade9a97552c46c33a5edf855ef8e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"jg", "generate", "shell", shells: [:bash, :zsh, :fish, :pwsh])
    system bin/"jg", "generate", "man", "--output-dir", man1
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jg --version")

    assert_equal "2\n", pipe_output("#{bin}/jg -F bar", '{"foo":1, "bar":2}')
  end
end