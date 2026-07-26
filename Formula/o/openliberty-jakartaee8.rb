class OpenlibertyJakartaee8 < Formula
  desc "Lightweight open framework for Java (Jakarta EE 8)"
  homepage "https://openliberty.io"
  url "https://public.dhe.ibm.com/ibmdl/export/pub/software/openliberty/runtime/release/26.0.0.7/openliberty-javaee8-26.0.0.7.zip"
  sha256 "c436e8efa564930b942c541b92103d05fd59dfa06e58b3e21475af211787eee5"
  license "EPL-1.0"

  livecheck do
    url "https://openliberty.io/api/builds/data"
    regex(/openliberty[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "737a1fdf255ad38a92bce0820c897e1aa0f7da65f3b31cbb4717cc9b3c635998"
  end

  depends_on "openjdk"

  def install
    rm_r(Dir["bin/**/*.bat"])

    libexec.install Dir["*"]
    (bin/"openliberty-jakartaee8").write_env_script "#{libexec}/bin/server",
                                                    Language::Java.overridable_java_home_env
  end

  def caveats
    <<~EOS
      The home of Open Liberty Jakarta EE 8 is:
        #{opt_libexec}
    EOS
  end

  test do
    ENV["WLP_USER_DIR"] = testpath
    output_log = testpath/"output.log"

    pid = spawn bin/"openliberty-jakartaee8", "run", [:out, :err] => output_log.to_s
    begin
      sleep 5 until output_log.exist? && output_log.read.include?("CWWKF0011I")
      assert_match "<feature>javaee-8.0</feature>", (testpath/"servers/defaultServer/server.xml").read
    ensure
      system bin/"openliberty-jakartaee8", "stop"
    end

    Process.wait(pid)
    assert_match "CWWKE0036I", output_log.read
  end
end