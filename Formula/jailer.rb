class Jailer < Formula
  desc "Database Subsetting and Relational Data Browsing Tool"
  homepage "https:wisser.github.ioJailer"
  url "https:github.comWisserJailerreleasesdownload15.8jailer_15.8.zip"
  sha256 "df29d1187259cb8a96dd0253b98896cff87ea1afe054a6195fe019fb57c7a9b1"

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