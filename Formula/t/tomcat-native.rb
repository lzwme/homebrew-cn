class TomcatNative < Formula
  desc "Lets Tomcat use some native resources for performance"
  homepage "https://tomcat.apache.org/native-doc/"
  url "https://www.apache.org/dyn/closer.lua?path=tomcat/tomcat-connectors/native/2.0.16/source/tomcat-native-2.0.16-src.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-connectors/native/2.0.16/source/tomcat-native-2.0.16-src.tar.gz"
  sha256 "785fdd99a202f442b085bc718d2fbeb393b85979aa4a2943302118c4acd68630"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "28eba952cb5b7035af70544a661c529af93072c3efa1a6cd0cd3a10542706fec"
    sha256 cellar: :any, arm64_tahoe:       "9cfb2599e7f56cadf3d413028cabb8aadeedf51ef7e683c78ad52327d98b16e3"
    sha256 cellar: :any, arm64_sequoia:     "c1cb3af230cc5c1f2031686bd9286f5cbc67bbeaa5f25f7982c187d1e1e6c95a"
    sha256 cellar: :any, arm64_linux:       "b7b4eb5fe0b4809e81787265c466b79eb94727f3c995f5027cdb2834c7bdedf0"
    sha256 cellar: :any, x86_64_linux:      "45ddf4ee5eb2732cf29acecd83cbac0eafe47e6e3677ab1a51c89f7aaba5c1b0"
  end

  depends_on "tomcat" => :test
  depends_on "apr"
  depends_on "openjdk"
  depends_on "openssl@4"

  allow_network_access! :test

  def install
    cd "native" do
      system "./configure", "--with-apr=#{formula_opt_prefix("apr")}",
                            "--with-java-home=#{formula_opt_prefix("openjdk")}",
                            "--with-ssl=#{formula_opt_prefix("openssl@4")}",
                            *std_configure_args
      system "make"
      system "make", "install"
    end
  end

  def caveats
    <<~EOS
      In order for tomcat's APR lifecycle listener to find this library, you'll
      need to add it to java.library.path. This can be done by adding this line
      to $CATALINA_HOME/bin/setenv.sh

        CATALINA_OPTS="$CATALINA_OPTS -Djava.library.path=#{opt_lib}"

      If $CATALINA_HOME/bin/setenv.sh doesn't exist, create it and make it executable.
    EOS
  end

  test do
    ENV["CATALINA_BASE"] = testpath
    tomcat = Formula["tomcat"]
    cp_r tomcat.libexec.children, testpath
    (testpath/"bin/setenv.sh").write <<~SH
      CATALINA_OPTS="$CATALINA_OPTS -Djava.library.path=#{opt_lib}"
    SH
    chmod "+x", "bin/setenv.sh"

    pid = spawn(tomcat.bin/"catalina", "start")
    sleep 10
    begin
      system tomcat.bin/"catalina", "stop"
    ensure
      Process.wait pid
    end

    output = (testpath/"logs/catalina.out").read
    assert_match(/Loaded Apache Tomcat Native library .* using APR version/, output)
    assert_match "OpenSSL successfully initialized", output
  end
end