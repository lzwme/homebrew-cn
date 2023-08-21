class Jailer < Formula
  desc "Database Subsetting and Relational Data Browsing Tool"
  homepage "https://wisser.github.io/Jailer"
  url "https://ghproxy.com/https://github.com/Wisser/Jailer/releases/download/v15.1.5/jailer_15.1.5.zip"
  sha256 "4206966fc536e7b701a612487e918d241ecd6bb516e2fe648d3ed9c8d8c3df83"

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