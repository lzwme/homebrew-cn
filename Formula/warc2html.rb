class Warc2html < Formula
  desc "Converts WARC files to static HTML"
  homepage "https:github.comiipcwarc2html"
  url "https:github.comiipcwarc2htmlreleasesdownloadv0.1.0warc2html-0.1.0.jar"
  sha256 "b6c57ae43c17befdf7fcd4c8a536a1bf4812a75fc23502e91a791510202540a9"

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    Pathname.glob("#{libexec}*.jar") do |file|
      bin.write_jar_script file, "warc2html"
    end
  end
end