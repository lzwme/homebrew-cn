class Jailer < Formula
  desc "Database Subsetting and Relational Data Browsing Tool"
  homepage "https://wisser.github.io/Jailer"
  url "https://ghfast.top/https://github.com/Wisser/Jailer/releases/download/v16.9/jailer_16.9.zip"
  sha256 "56325b279382bf338eeaf7523c10fbcbff135b9890d1ab582984662349a443b2"

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    Pathname.glob("#{libexec}/*.sh") do |file|
      basename = "" + file.basename
      basename = basename.delete_suffix(".sh")
      (bin/basename).write_env_script file, Language::Java.overridable_java_home_env
    end
  end

  test do
    system bin/"jailer"
  end
end