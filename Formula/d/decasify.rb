class Decasify < Formula
  desc "Utility for casting strings to title-case according to locale-aware style guides"
  homepage "https:github.comalerquedecasify"
  url "https:github.comalerquedecasifyreleasesdownloadv0.8.0decasify-0.8.0.tar.zst"
  sha256 "1d35006ffc8bdc7e01fe7fc471dfdf0e99d3622ab0728fc4d3bb1aea9148214e"
  license "LGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8b5386f476925d6f20293218d68ea2cbcac1f3e980962dc03348fdac3f1683f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76960d71c309de0374ee48d16a4f524a698d11adc8426d1190a7255796a21116"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e2fe6e8b7df76008f89c75af0e3a4058a405dc71dfa6fd5b7d3b52b1df6ea340"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ad9027b9152c5723ed5f51cb2b75bf1ec95fb9932c5dcffe3fb7fa03cffd799"
    sha256 cellar: :any_skip_relocation, ventura:       "ee363def64c1cc08877ca2cb12353621e5ef6a2933c03dd9f677888709fdcc80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff678b34b40f353aafbb695fa48e93efa183818093cf7a460295a9d901ba7e50"
  end

  head do
    url "https:github.comalerquedecasify.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "jq" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system ".bootstrap.sh" if build.head?
    system ".configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "decasify v#{version}", shell_output("#{bin}decasify --version")
    assert_match "Ben ve İvan", shell_output("#{bin}decasify -l tr -c title 'ben VE ivan'")
  end
end