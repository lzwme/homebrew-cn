class ApacheOpennlp < Formula
  desc "Machine learning toolkit for processing natural language text"
  homepage "https:opennlp.apache.org"
  url "https:www.apache.orgdyncloser.lua?path=opennlpopennlp-2.5.2apache-opennlp-2.5.2-bin.tar.gz"
  mirror "https:archive.apache.orgdistopennlpopennlp-2.5.2apache-opennlp-2.5.2-bin.tar.gz"
  sha256 "d515781b1444038dad6433ee8414f535bac3b244f126b3b5479a5b021bf22246"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6af9c46ca1928c9e35c8797e91e2fb853549a982447902642fec5ee99975fa9d"
  end

  depends_on "openjdk"

  # build patch to remove quote for `$HEAP`, upstream pr ref, https:github.comapacheopennlppull734
  patch :DATA

  def install
    # Remove Windows scripts
    rm(Dir["bin*.bat"])

    libexec.install Dir["*"]
    (bin"opennlp").write_env_script libexec"binopennlp", JAVA_HOME:    Formula["openjdk"].opt_prefix,
                                                            OPENNLP_HOME: libexec
  end

  test do
    assert_equal "Hello , friends", pipe_output("#{bin}opennlp SimpleTokenizer", "Hello, friends").lines.first.chomp
  end
end

__END__
diff --git abinopennlp bbinopennlp
index 8375e2d..c1c2984 100755
--- abinopennlp
+++ bbinopennlp
@@ -58,4 +58,4 @@ if [ -n "$JAVA_HEAP" ] ; then
   HEAP="-Xmx$JAVA_HEAP"
 fi

-$JAVACMD "$HEAP" -Dlog4j.configurationFile="$OPENNLP_HOMEconflog4j2.xml" -cp "$CLASSPATH" opennlp.tools.cmdline.CLI "$@"
+$JAVACMD $HEAP -Dlog4j.configurationFile="$OPENNLP_HOMEconflog4j2.xml" -cp "$CLASSPATH" opennlp.tools.cmdline.CLI "$@"