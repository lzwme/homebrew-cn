class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https:github.comswsnrmdcat"
  url "https:github.comswsnrmdcatarchiverefstagsmdcat-2.6.1.tar.gz"
  sha256 "0dac8322b74d3eefc412ea13fca448aac43b257a3ff3e361d3343c6220a6618f"
  license "MPL-2.0"
  head "https:github.comswsnrmdcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c26c22a9efb034b2b8d562af1621099ce62d70908b1f303acc61460355211f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "381588c26928902bad2f8b21d6b2cf9fcac7fa1c2697972cdbd9b1f4a0ce3497"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "613dddcd20631d34b8349dc2915e1214ad9f34deec489d5e83c68b36501281ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae56e8127ef9d13c94fe29e19da32bc8d5f43ceb09361b07254a766076a71be7"
    sha256 cellar: :any_skip_relocation, ventura:       "3d15ec90a4ab3121b98080e412ccfd1b25864d42695aa5acac988f3ecfeace80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa7d5f06422524927d87e1c53333548ed11980a39de2b7befc0bcbd8137b8e42"
  end

  depends_on "asciidoctor" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args

    # https:github.comswsnrmdcat?tab=readme-ov-file#packaging
    generate_completions_from_executable(bin"mdcat", "--completions")
    system "asciidoctor", "-b", "manpage", "-a", "reproducible", "-o", "mdcat.1", "mdcat.1.adoc"
    man1.install Utils::Gzip.compress("mdcat.1")
  end

  test do
    (testpath"test.md").write <<~MARKDOWN
      _lorem_ **ipsum** dolor **sit** _amet_
    MARKDOWN
    output = shell_output("#{bin}mdcat --no-colour test.md")
    assert_match "lorem ipsum dolor sit amet", output
  end
end