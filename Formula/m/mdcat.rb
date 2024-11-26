class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https:github.comswsnrmdcat"
  url "https:github.comswsnrmdcatarchiverefstagsmdcat-2.7.0.tar.gz"
  sha256 "e372a82291a139f95d77c12325a2f595f47f6d6b4c2de70e50ab2117e975734f"
  license "MPL-2.0"
  head "https:github.comswsnrmdcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca38875152be98d69833fbb90851625cad41ea408d2988d1b692e0514eea7d6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "919a746231ece9f3525138673946ad329656f3eb58970ee356f614aaa91eaeb9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "53f91d8e89afb3542a7a496027fd41a37935a0cd99d5d0a6fc36081d86187856"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe51c3e6cfc2b64039d1b9ce584b9b9655c293c76f5fae35737a3d94e1da9f01"
    sha256 cellar: :any_skip_relocation, ventura:       "9ffb94fac81a11124aa4668fbbc4a35891706a915f18b9c3e29f5262b8f2c549"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36ad557b7e0f95bf84b13d2fd11fb8592ffac94a5fd9207d92436e3e7b23ac6a"
  end

  depends_on "asciidoctor" => :build
  depends_on "rust" => :build

  uses_from_macos "curl"

  on_linux do
    depends_on "pkgconf" => :build
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