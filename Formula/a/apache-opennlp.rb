class ApacheOpennlp < Formula
  desc "Machine learning toolkit for processing natural language text"
  homepage "https://opennlp.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=opennlp/opennlp-2.3.1/apache-opennlp-2.3.1-bin.tar.gz"
  mirror "https://archive.apache.org/dist/opennlp/opennlp-2.3.1/apache-opennlp-2.3.1-bin.tar.gz"
  sha256 "4637782175fef7992f3a125a967064bf502de99532988dda305a0b0159d6f970"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9759a306f4fbe30d14a5c329ef8f6a46c0ce2417c689269153f701a1a0094c9a"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    (bin/"opennlp").write_env_script libexec/"bin/opennlp", JAVA_HOME:    Formula["openjdk"].opt_prefix,
                                                            OPENNLP_HOME: libexec
    # script uses a relative path to the conf folder
    inreplace libexec/"bin/opennlp", "../conf", "$OPENNLP_HOME/conf"
  end

  test do
    assert_equal "Hello , friends", pipe_output("#{bin}/opennlp SimpleTokenizer", "Hello, friends").lines.first.chomp
  end
end