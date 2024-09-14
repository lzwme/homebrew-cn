class Fanyi < Formula
  desc "Chinese and English translate tool in your command-line"
  homepage "https:github.comafc163fanyi"
  url "https:registry.npmjs.orgfanyi-fanyi-9.0.2.tgz"
  sha256 "9cdf1d8fbbd7ccc442b49c49cffbc70ef955fa04e74bf463a3c378da10fe68bd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "79e56b0b5ab12581cb88e33f0a1413b9dfaacaeb876c538b80fa25c18d8bad71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "79e56b0b5ab12581cb88e33f0a1413b9dfaacaeb876c538b80fa25c18d8bad71"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79e56b0b5ab12581cb88e33f0a1413b9dfaacaeb876c538b80fa25c18d8bad71"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79e56b0b5ab12581cb88e33f0a1413b9dfaacaeb876c538b80fa25c18d8bad71"
    sha256 cellar: :any_skip_relocation, sonoma:         "14b94f46a7c03117bc78e7a012325796e005d0a6ddc4d7eb6c595a692f3f3cb9"
    sha256 cellar: :any_skip_relocation, ventura:        "14b94f46a7c03117bc78e7a012325796e005d0a6ddc4d7eb6c595a692f3f3cb9"
    sha256 cellar: :any_skip_relocation, monterey:       "14b94f46a7c03117bc78e7a012325796e005d0a6ddc4d7eb6c595a692f3f3cb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae5ef133343ea7ab08e3d3e643ccf365aac5cad11fc1709c89c1550bca46d552"
  end

  depends_on "node"

  on_macos do
    depends_on "macos-term-size"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir[libexec"bin*"]

    term_size_vendor_dir = libexec"libnode_modules"name"node_modulesterm-sizevendor"
    rm_r(term_size_vendor_dir) # remove pre-built binaries

    if OS.mac?
      macos_dir = term_size_vendor_dir"macos"
      macos_dir.mkpath
      # Replace the vendored pre-built term-size with one we build ourselves
      ln_sf (Formula["macos-term-size"].opt_bin"term-size").relative_path_from(macos_dir), macos_dir
    end
  end

  test do
    assert_match "爱", shell_output("#{bin}fanyi love 2>devnull")
  end
end