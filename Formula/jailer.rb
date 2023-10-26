class Jailer < Formula
  desc "Database Subsetting and Relational Data Browsing Tool"
  homepage "https://wisser.github.io/Jailer"
  url "https://ghproxy.com/https://github.com/Wisser/Jailer/releases/download/15.2.4/jailer_15.2.4.zip"
  sha256 "fb57031d2fbf6380627ebd7903e71653facdd4ff336abcbea5f5fd1df8262ee0"

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
    system "#{bin}/jailer"
  end
end