class OilsForUnix < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://oils.pub/"
  url "https://oils.pub/download/oils-for-unix-0.32.0.tar.gz"
  sha256 "26dde977d20dd0a373a7d450d063fa50be672da4875d55e9749e8ff18eedd254"
  license "Apache-2.0"

  livecheck do
    url "https://oils.pub/releases.html"
    regex(/href=.*?oils-for-unix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0bc26590d3d6c987e1f88487874bd463d698a2a2cc67b312e093cf3d3acdd6b3"
    sha256 cellar: :any,                 arm64_sonoma:  "b7a526c27cad1e6fe645df68cf9b42b64ee59877ef9043e146051a2fbe3428c0"
    sha256 cellar: :any,                 arm64_ventura: "1282e142ae7af7856ace88539a3a211b06d9dc495991ca6b588bcc0236c07f22"
    sha256 cellar: :any,                 sonoma:        "12af4348b5a821eea0db19a922be6dde729757f035d9f97eb7114693ca0d4214"
    sha256 cellar: :any,                 ventura:       "0c705ce544b77431e7c80abee91baac75ffe406da4e91f35221d529ff4f1681c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af67c3d454778ddfd642a09035c6ace38168cdc2f3595bb07646ba0056157e4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "110f40c090456268a7dda4a232577c4f4efe3ddfb355e51085b7bafe7f7dfe63"
  end

  depends_on "readline"

  conflicts_with "oil", because: "both install 'osh' and 'ysh' binaries"
  conflicts_with "etsh", "omake", because: "both install 'osh' binaries"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--datarootdir=#{share}",
                          "--readline=#{Formula["readline"].opt_prefix}",
                          "--with-readline"
    system "_build/oils.sh"
    system "./install"
  end

  test do
    system bin/"osh", "-c", "shopt -q parse_backticks"
    assert_equal testpath.to_s, shell_output("#{bin}/osh -c 'echo `pwd -P`'").strip

    system bin/"ysh", "-c", "shopt -u parse_equals"
    assert_equal "bar", shell_output("#{bin}/ysh -c 'var foo = \"bar\"; write $foo'").strip
  end
end