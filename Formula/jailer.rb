class Jailer < Formula
  desc "Database Subsetting and Relational Data Browsing Tool"
  homepage "https://wisser.github.io/Jailer"
  url "https://ghproxy.com/https://github.com/Wisser/Jailer/releases/download/v14.4/jailer_14.4.zip"
  sha256 "fa2607ddeaeed3ec1269d840dda17fdeaedbe1f38691d5ac60c16f333c025997"

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