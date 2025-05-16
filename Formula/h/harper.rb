class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https:writewithharper.com"
  url "https:github.comAutomatticharperarchiverefstagsv0.36.0.tar.gz"
  sha256 "426a0432e59c04cd14173c5e301bc5122344e4a2099bc5a2baaf70f43ffd51ca"
  license "Apache-2.0"
  head "https:github.comAutomatticharper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f398df19ef15610a7ddcaad20db27eb54313a8958bd562a4ffddfbd7c7c6d0a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60807f65be439f026e9d617f90c7216c2579598915f84a8af52880065e5b356f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d34f8c98f447d05d9c11a2cd0da0fdf852af62888f259f2f0d881464879e82c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "b08ed8e9b74f8d47190e3f43294a840767a8dd28f718de56c097dd441c3c3847"
    sha256 cellar: :any_skip_relocation, ventura:       "4c82bdab9fe5810bc460913251b4c70b838a5370dab93b06bb942513a5da0154"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0e74673cdb30d856bba631cb7d0916d7b1fb7871e1bc7655f3e957fd06dd487"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46530e3a118dc057bd899eee71f6cfd257e2bd35cd64680a4106f8ba3bf857db"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "harper-cli")
    system "cargo", "install", *std_cargo_args(path: "harper-ls")
  end

  test do
    # test harper-cli
    (testpath"test.md").write <<~MARKDOWN
      # Hello Harper

      This is an example to ensure language detection works properly.
    MARKDOWN

    # Dialect in https:github.comAutomatticharperblob833b212e8665567fa2912e6c07d7c83d394dd449harper-coresrcword_metadata.rs#L357-L362
    system bin"harper-cli", "lint", "--dialect", "American", "test.md"

    output = shell_output("#{bin}harper-cli parse test.md")
    assert_equal "Word", JSON.parse(output.lines.first)["kind"]["kind"]

    assert_match "\"iteration\"", shell_output("#{bin}harper-cli words")

    # test harper-ls
    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON
    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = pipe_output("#{bin}harper-ls --stdio 2>&1", input)
    assert_match(^Content-Length: \d+i, output)
  end
end