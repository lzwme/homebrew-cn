class Jailer < Formula
  desc "Database Subsetting and Relational Data Browsing Tool"
  homepage "https:wisser.github.ioJailer"
  url "https:github.comWisserJailerreleasesdownloadv16.5.9jailer_16.5.9.zip"
  sha256 "5f9fe4f5d0fe80f2de3db70d6175e807d88c3c37c0f12496ffa53e8f0be60006"

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
    system bin"jailer"
  end
end