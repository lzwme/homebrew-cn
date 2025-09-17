class Jailer < Formula
  desc "Database Subsetting and Relational Data Browsing Tool"
  homepage "https://wisser.github.io/Jailer"
  url "https://ghfast.top/https://github.com/Wisser/Jailer/releases/download/v16.9.1/jailer_16.9.1.zip"
  sha256 "cbe15fa1ad9ac043e92aa606816e147ca20dca0111402e07abe4a36ce5100178"

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