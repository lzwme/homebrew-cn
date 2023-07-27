class Jailer < Formula
  desc "Database Subsetting and Relational Data Browsing Tool"
  homepage "https://wisser.github.io/Jailer"
  url "https://ghproxy.com/https://github.com/Wisser/Jailer/releases/download/v15.1.3/jailer_15.1.3.zip"
  sha256 "ef0c31e1ad913c0d204809dd83c7496e5646910addc12ad565b4f10b0d1ed65c"

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