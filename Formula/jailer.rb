class Jailer < Formula
  desc "Database Subsetting and Relational Data Browsing Tool"
  homepage "https:wisser.github.ioJailer"
  url "https:github.comWisserJailerreleasesdownloadv16.5jailer_16.5.zip"
  sha256 "4e71752d5c9239e5970efb6c11a55ff0e8e6fd259e28af205ba3c86c66d381d3"

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    Pathname.glob("#{libexec}*.sh") do |file|
      basename = "" + file.basename
      basename = basename.delete_suffix(".sh")
      (binbasename).write_env_script file, Language::Java.overridable_java_home_env
    end
  end

  test do
    system "#{bin}jailer"
  end
end