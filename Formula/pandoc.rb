class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://ghproxy.com/https://github.com/jgm/pandoc/archive/refs/tags/3.1.5.tar.gz"
  sha256 "31f84b86c18b3de051f218483aa6a0d8660aa6da73f10bbf7ea4188cb44d3922"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/pandoc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "161e5d5146d62458d307f5187bab3323238b71428547a9661d924e0eb4dd3f86"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31e509505a0ab006c5d7c0ae72ec3e22827661acc26b14f25965ef6f997db892"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2433f6d138cfcfd30155f745a85d653a36b6c29e00cdb94e74f3a9d0020d984c"
    sha256 cellar: :any_skip_relocation, ventura:        "b7facc034a01fda1057ce0109688b869b9eeb74163c571823c7c8d10b617fc1d"
    sha256 cellar: :any_skip_relocation, monterey:       "ef805488f2df19366a538a0b08355ee6da62d1ac127b226b6009736aaa09cef9"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e12a50fcc7fe35deb253221029ebcbf16da3514da0fb88fcb8191199df9da37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd645d8d33d0bea81b743ab9e2976c48f1843aa14f4df442ff09ab1819cde7fc"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "unzip" => :build # for cabal install
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args, "pandoc-cli"
    generate_completions_from_executable(bin/"pandoc", "--bash-completion",
                                         shells: [:bash], shell_parameter_format: :none)
    man1.install "man/pandoc.1"
  end

  test do
    input_markdown = <<~EOS
      # Homebrew

      A package manager for humans. Cats should take a look at Tigerbrew.
    EOS
    expected_html = <<~EOS
      <h1 id="homebrew">Homebrew</h1>
      <p>A package manager for humans. Cats should take a look at
      Tigerbrew.</p>
    EOS
    assert_equal expected_html, pipe_output("#{bin}/pandoc -f markdown -t html5", input_markdown)
  end
end