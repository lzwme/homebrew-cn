class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/swsnr/mdcat"
  url "https://ghproxy.com/https://github.com/swsnr/mdcat/archive/refs/tags/mdcat-2.1.0.tar.gz"
  sha256 "96ed4b74c202514987610a69af7fc71afd3b826d0449f9326661fd5244c5d5ee"
  license "MPL-2.0"
  revision 1
  head "https://github.com/swsnr/mdcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9eff2b11b0fedccc888d3ac76249dfaddf063713ed24d0e9a1883a21c490640d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fdd03eb1daabf38c5738bf70dcc72cb703887664d568d7f163384f407534b722"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5262117d6249c644b8882c419e07ffb5062a86b6bf5fce224dec381b61df3e2a"
    sha256 cellar: :any_skip_relocation, sonoma:         "8f6803b4e3a19ec367070fe93215946395bfbe61ff8ca62d8767c937b1e9eccf"
    sha256 cellar: :any_skip_relocation, ventura:        "0d22cae51336078dc7c821f2b5faa0463e7f9e684461d65a9102d19a6ea4f126"
    sha256 cellar: :any_skip_relocation, monterey:       "3e6708dec18697cc4be63237b931257f3dc6f66b6964d848f701ef87ba89b55f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "495dee7dd31bc5bd4b90edf85856ef19e798013e88e8ec7829dff859b82fe11b"
  end

  depends_on "asciidoctor" => :build
  depends_on "cmake" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args

    outdir = Dir["target/release/build/mdcat-*/out"].first
    man1.install "#{outdir}/mdcat.1"
    bash_completion.install "#{outdir}/completions/mdcat.bash" => "mdcat"
    fish_completion.install "#{outdir}/completions/mdcat.fish"
    zsh_completion.install "#{outdir}/completions/_mdcat"
  end

  test do
    (testpath/"test.md").write <<~EOS
      _lorem_ **ipsum** dolor **sit** _amet_
    EOS
    output = shell_output("#{bin}/mdcat --no-colour test.md")
    assert_match "lorem ipsum dolor sit amet", output
  end
end