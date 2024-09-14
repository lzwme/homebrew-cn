class Liblouis < Formula
  desc "Open-source braille translator and back-translator"
  homepage "https:liblouis.io"
  url "https:github.comliblouisliblouisreleasesdownloadv3.31.0liblouis-3.31.0.tar.gz"
  sha256 "29286fe9edc9c7119941b0c847aa9587021f0e53f5623aa03ddfd5e285783af5"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 arm64_sequoia:  "b96b6d21b3fbb02bf2c571e6f2f397747fbd9bd43df4b6cfe3b9031c9d4e3ebf"
    sha256 arm64_sonoma:   "b65a856cdf1f7c2071038f2f547f89ab3b10fc40204045973dbe76bfc9014357"
    sha256 arm64_ventura:  "f7bb5f9884597f1be64eb95141077d8422a8f1823ddb3df7cacb53c6e6567958"
    sha256 arm64_monterey: "7e48ca6c4737e17b301eb022307bfc8e0806402ef80b79fa02edc1b391bd8d22"
    sha256 sonoma:         "918a89c8c736f631714aa77d84542dec7d34e2fbf143454ead3800fcf44d5e60"
    sha256 ventura:        "80d938120d66f08644ca9cf5fdc09a4cabe21aca8890e9fabce4c68aac59d0ad"
    sha256 monterey:       "da8ed9e6c6a91d4738d7942cce5de956efebd8e13395101cace9259279352d40"
    sha256 x86_64_linux:   "5cd328ee88eb01fd3a493908aacc943b438cbf823bfe8d4d815ad82031911fef"
  end

  head do
    url "https:github.comliblouisliblouis.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "help2man" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12"

  uses_from_macos "m4"

  def python3
    "python3.12"
  end

  def install
    system ".autogen.sh" if build.head?
    system ".configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "check"
    system "make", "install"
    system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), ".python"
    (prefix"tools").install bin"lou_maketable", bin"lou_maketable.d"
  end

  test do
    assert_equal "⠼⠙⠃", pipe_output("#{bin}lou_translate unicode.dis,en-us-g2.ctb", "42")

    (testpath"test.py").write <<~EOS
      import louis
      print(louis.translateString(["unicode.dis", "en-us-g2.ctb"], "42"))
    EOS
    assert_equal "⠼⠙⠃", shell_output("#{python3} test.py").chomp
  end
end