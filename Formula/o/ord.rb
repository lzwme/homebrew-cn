class Ord < Formula
  desc "Index, block explorer, and command-line wallet"
  homepage "https:ordinals.com"
  url "https:github.comordinalsordarchiverefstags0.20.0.tar.gz"
  sha256 "6d0c61e7657b1a76717a7c93109bbc5de0e11c27733098a3ee972d3b7b407d72"
  license "CC0-1.0"
  head "https:github.comordinalsord.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e5c25a2646af6cfd11773436d95a4924850b03c6d9c97420f9679e4125648e75"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70a702d1f1db605cc5c661b89d658a6a2bfb0f981ff35947aac2631b4f97c8c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "241cf0c83aa50d199e723cfb9669324ba4e1490e9ba7c30683d015d4a6fd0904"
    sha256 cellar: :any_skip_relocation, sonoma:         "1edf24dd01838d5bdebb5b2360008db2b7ec5be35d3c15ddd9abcc31f29f24e5"
    sha256 cellar: :any_skip_relocation, ventura:        "1e7030adf86d6b58695947b8efe9517288b152d6925e87bfa16b23d8c8dc520d"
    sha256 cellar: :any_skip_relocation, monterey:       "10a9282b42ebfa6e08610a510d05614a67909b92932a3270d72db9ba09cc911b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17096fd535dd5ed2f999fcaa63f543d9189026f606a77de755b233b5d451ccea"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}ord list xx:xx 2>&1", 2)
    assert_match "invalid value 'xx:xx' for '<OUTPOINT>': error parsing TXID", output

    assert_match "ord #{version}", shell_output("#{bin}ord --version")
  end
end