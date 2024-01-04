class OpenAdventure < Formula
  desc "Colossal Cave Adventure, the 1995 430-point version"
  homepage "http://www.catb.org/~esr/open-adventure/"
  url "http://www.catb.org/~esr/open-adventure/advent-1.17.tar.gz"
  sha256 "2ed2c82dd4881fb8bd220236aac052f62c880d88427da32d01f0a17b0c28a195"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/open-adventure.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?advent[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "affc0c9f553c48d7b9bdfdf5629fd7bb0c511b9da3576c23de74d824d885c8c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c6683350d5d085b5cfb1005e03ada81d56cda6b633f07125e94831614c05e21a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f39dec45d4cad994c77e194507a6209ee319209155a025c3581b092ddaab7da2"
    sha256 cellar: :any_skip_relocation, sonoma:         "7bcaf1493b96a2ffaace4b5d67869989cb59dbe42f9ef38c97e075a51499f0ca"
    sha256 cellar: :any_skip_relocation, ventura:        "f7dd11b2cd116c44acdca12d6030c193ee4477b5c9a010841bd2d58b0ae6552a"
    sha256 cellar: :any_skip_relocation, monterey:       "ba0e05dee029ef2291bddfb8766a7b31558406909dbc1cdae2fa20f4f99b9084"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7dc77aa96b3445e40c68391730034e12a23acc84768128bef23cb544885d9b18"
  end

  depends_on "asciidoc" => :build
  depends_on "python@3.12" => :build
  depends_on "pyyaml" => :build

  uses_from_macos "libxml2" => :build
  uses_from_macos "libedit"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    python = Formula["python@3.12"].opt_bin/"python3.12"
    system python, "./make_dungeon.py"
    system "make"
    bin.install "advent"
    system "make", "advent.6"
    man6.install "advent.6"
  end

  test do
    # there's no apparent way to get non-interactive output without providing an invalid option
    output = shell_output("#{bin}/advent --invalid-option 2>&1", 1)
    assert_match "Usage: #{bin}/advent", output
  end
end