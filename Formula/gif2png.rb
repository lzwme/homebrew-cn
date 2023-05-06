class Gif2png < Formula
  desc "Convert GIFs to PNGs"
  homepage "http://www.catb.org/~esr/gif2png/"

  # Use canonical URL http://www.catb.org/~esr/gif2png/gif2png-<version>.tar.gz instead
  # once it starts to include go.mod/go.sum
  # See https://gitlab.com/esr/gif2png/-/issues/14#note_1373069233.
  url "https://gitlab.com/esr/gif2png/-/archive/3.0.2/gif2png-3.0.2.tar.bz2"
  sha256 "4f3a77c481d040be6e249e788291f19345668ce867bda12043e30409726b67de"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/gif2png.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?gif2png[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "66e6fb0ca0d1377fd4d29df7516d43cf2fbdaf9d3430b7ed0e1f5abba9c79acf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "174c333d52577ee0cebce92bd5eab8997fde812b8095628affe326240388722b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "27460a003c495b757d85413418a1a43685723c2fbf7ec5d98d2e13ad8108ea53"
    sha256 cellar: :any_skip_relocation, ventura:        "0a7fe6a1ced046933db99574d9d3755dcb433e4360f1b197ef52268dded6675b"
    sha256 cellar: :any_skip_relocation, monterey:       "0ce587536912edf98baf20a107bb6c1e1ab9233b11a61a3509f17594dc5d293b"
    sha256 cellar: :any_skip_relocation, big_sur:        "e1a01df4abf53b34579e414b1aa1bfef5a6606276632976e71bb527f7573ca50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afca6f1261a57f5ce4516ff95a9c252fdd1a051fcfe4da520b1f2d9cbf19f733"
  end

  depends_on "go" => :build
  depends_on "xmlto" => :build

  uses_from_macos "python" # for web2png

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    system "make", "install", "prefix=#{prefix}"
  end

  test do
    pipe_output "#{bin}/gif2png -O", File.read(test_fixtures("test.gif"))
  end
end