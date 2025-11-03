class Jailer < Formula
  desc "Database Subsetting and Relational Data Browsing Tool"
  homepage "https://wisser.github.io/Jailer"
  url "https://ghfast.top/https://github.com/Wisser/Jailer/releases/download/v16.10/jailer_16.10.zip"
  sha256 "a7dcd3ab3d0c5c436118418e37ae9c4237a8e31e99d264e5532bf3dad310f53e"

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