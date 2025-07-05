class Jailer < Formula
  desc "Database Subsetting and Relational Data Browsing Tool"
  homepage "https://wisser.github.io/Jailer"
  url "https://ghfast.top/https://github.com/Wisser/Jailer/releases/download/v16.7/jailer_16.7.zip"
  sha256 "b930ac7042a5751c5391bf58876aa5bdc6e04bbb8be2a8b4174e26583083005d"

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