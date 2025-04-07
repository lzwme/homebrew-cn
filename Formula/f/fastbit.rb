class Fastbit < Formula
  desc "Open-source data processing library in NoSQL spirit"
  homepage "https:sdm.lbl.govfastbit"
  # Upstream download url is blocking access: Cloudflare Error 1006: IP Address Restriction
  # Use an archived copy from archive.org until upstream url is restored
  url "https:web.archive.orgweb20210319090732code.lbl.govfrsdownload.phpfile426fastbit-2.0.3.tar.gz"
  mirror "https:code.lbl.govfrsdownload.phpfile426fastbit-2.0.3.tar.gz"
  sha256 "1ddb16d33d869894f8d8cd745cd3198974aabebca68fa2b83eb44d22339466ec"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "1474f36207d0c52b2b6f37570476043036fc324462ea4e641fc6c42684b69f0b"
    sha256 cellar: :any,                 arm64_sonoma:   "f7225849b4ad234bdc241a601ac7815c22fef58cc76c2a5a0c2e9efca5ed3db8"
    sha256 cellar: :any,                 arm64_ventura:  "d4860526007422d2c3f3d2857f4af11daac63b571050b1d60994b24a5170ad5b"
    sha256 cellar: :any,                 arm64_monterey: "cb5166c40241b15850b828ec9719276cea4931305701458adfe41c74f88cf72d"
    sha256 cellar: :any,                 arm64_big_sur:  "09dc75c92fa358be93b38636c4e747d0768af669e396b07854975684bdba8494"
    sha256 cellar: :any,                 sonoma:         "23acbeb6b15b341dc87d2d101bd4b504633554afa754a652c33e4ef86814814b"
    sha256 cellar: :any,                 ventura:        "93657ebe3a5ba3c353cf57f060771777f9e34334624bb76a5c769c3adf6ea7ca"
    sha256 cellar: :any,                 monterey:       "99413781b207c1e4c7911cc8eb8f300de0601fdf3c0092fe1f4c0c68f985562e"
    sha256 cellar: :any,                 big_sur:        "ce5bd1a75d14f7f11b2bdcb9cf63aebc63f3c722dd4a39380e50d2c8489b2347"
    sha256 cellar: :any,                 catalina:       "31e723c0610621033859357ab2a6dc373cf955847ab5c3dcf32696d260fa0de3"
    sha256 cellar: :any,                 mojave:         "0f9a32fe10c3e5c6e2826009f247bc55064ad5612dcda9724cda203c8b18e00e"
    sha256 cellar: :any,                 high_sierra:    "a7d7330e664e04191fe183050b588e4d3ad13aa101553f8f6965deb708c96d72"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "dfa19dae8cb7913a539c7940590873ef363462e06b7e68392bfd8e94ebfde0cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "198c4ca4965a0f5285fe2c887295f34dbd0481ec7eb6898d5cf325688dccfb96"
  end

  deprecate! date: "2024-06-18", because: :unmaintained

  depends_on "openjdk"

  conflicts_with "iniparser", because: "both install `includedictionary.h`"

  # Fix compilation with Xcode 9, reported by email on 2018-03-13
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patchesfe9d4e5fastbitxcode9.patch"
    sha256 "e1198caf262a125d2216d70cfec80ebe98d122760ffa5d99d34fc33646445390"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patches03cf8088210822aa2c1ab544ed58ea04c897d9c4libtoolconfigure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    ENV.cxx11
    args = ["--with-java=#{Formula["openjdk"].opt_prefix}"]
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system ".configure", *args, *std_configure_args
    system "make", "install"
    libexec.install lib"fastbitjni.jar"
    bin.write_jar_script libexec"fastbitjni.jar", "fastbitjni"
  end

  test do
    assert_equal prefix.to_s, shell_output("#{bin}fastbit-config --prefix").chomp
    (testpath"test.csv").write <<~CSV
      Potter,Harry
      Granger,Hermione
      Weasley,Ron
    CSV
    system bin"ardea", "-d", testpath, "-m", "a:t,b:t", "-t", testpath"test.csv"
  end
end