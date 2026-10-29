class ApacheSpark < Formula
  desc "Engine for large-scale data processing"
  homepage "https://spark.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=spark/spark-4.2.1/spark-4.2.1-bin-hadoop3.tgz"
  mirror "https://archive.apache.org/dist/spark/spark-4.2.1/spark-4.2.1-bin-hadoop3.tgz"
  version "4.2.1"
  sha256 "8766fd9132079ddf3f0b54a51796d05bf442871c62a51374ca9e18d345bb2bd6"
  license "Apache-2.0"
  head "https://github.com/apache/spark.git", branch: "master"

  # The download page creates file links using JavaScript, so we identify
  # versions within the related JS file.
  livecheck do
    url "https://spark.apache.org/js/downloads.js"
    regex(/addRelease\(.*?["']v?(\d+(?:\.\d+)+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f856f9473b66b9eab78f90d18d1e48d8dfcf9edcf0106d329811e8751cea3928"
  end

  depends_on "openjdk@21"

  def install
    # Rename beeline to distinguish it from hive's beeline
    mv "bin/beeline", "bin/spark-beeline"

    rm(Dir["bin/*.cmd"])
    libexec.install Dir["*"]
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", Language::Java.overridable_java_home_env("21"))
  end

  test do
    require "pty"

    (testpath/"data.txt").write <<~EOS
      Homebrew test
      Homebrew Spark test
      Spark test Homebrew
    EOS

    output = ""
    PTY.spawn(bin/"spark-shell") do |r, w, pid|
      w.puts "sc.parallelize(1 to 1000).count()"
      w.puts 'sc.textFile("data.txt").filter(line => line.contains("Spark")).first()'
      w.puts ":quit"
      begin
        r.each_line { |line| output += line }
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
      # remove ANSI colors
      output.encode!("UTF-8", "binary",
        invalid: :replace,
        undef:   :replace,
        replace: "")
      output.gsub!(/\e\[([;\d]+)?m/, "")
    ensure
      Process.kill("TERM", pid)
    end

    assert_match "Long = 1000", output
    assert_match "String = Homebrew Spark test", output
  end
end