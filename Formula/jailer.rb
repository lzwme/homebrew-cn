class Jailer < Formula
  desc "Database Subsetting and Relational Data Browsing Tool"
  homepage "https://wisser.github.io/Jailer"
  url "https://ghproxy.com/https://github.com/Wisser/Jailer/releases/download/v15.0/jailer_15.0.zip"
  sha256 "954338c5dabea957e2adcddbd2c858d04acf16729f32269d70c8412734332fa7"

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    Pathname.glob("#{libexec}/*.sh") do |file|
      basename = "" + file.basename
      basename = basename.delete_suffix(".sh")
      (bin/basename).write_env_script file, Language::Java.overridable_java_home_env
    end
  end
end