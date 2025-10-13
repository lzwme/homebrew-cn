class ApacheOpennlp < Formula
  desc "Machine learning toolkit for processing natural language text"
  homepage "https://opennlp.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=opennlp/opennlp-2.5.6/apache-opennlp-2.5.6-bin.tar.gz"
  mirror "https://archive.apache.org/dist/opennlp/opennlp-2.5.6/apache-opennlp-2.5.6-bin.tar.gz"
  sha256 "cebff9d389cb434c41395f3e1212795fea0825252a261952ed3bd6cad1f7e924"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a6c465c04a76f79cfe83ddee02f150293e9269de70671c6c6c97f38e669f6390"
  end

  depends_on "openjdk"

  def install
    # Remove Windows scripts
    rm(Dir["bin/*.bat"])

    libexec.install Dir["*"]
    (bin/"opennlp").write_env_script libexec/"bin/opennlp", JAVA_HOME:    Formula["openjdk"].opt_prefix,
                                                            OPENNLP_HOME: libexec
  end

  test do
    output = pipe_output("#{bin}/opennlp SimpleTokenizer", "Hello, friends", 0)
    assert_equal "Hello , friends", output.lines.first.chomp
  end
end