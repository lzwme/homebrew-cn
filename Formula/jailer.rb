class Jailer < Formula
  desc "Database Subsetting and Relational Data Browsing Tool"
  homepage "https://wisser.github.io/Jailer"
  url "https://ghfast.top/https://github.com/Wisser/Jailer/releases/download/v16.11/jailer_16.11.zip"
  sha256 "cdbf21854497e9519f73530c7bfb76c04725e1a9d01de79c20cb5aa3e94ff36f"

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