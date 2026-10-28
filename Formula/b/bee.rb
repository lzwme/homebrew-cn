class Bee < Formula
  desc "Tool for managing database changes"
  homepage "https://github.com/bluesoft/bee"
  url "https://ghfast.top/https://github.com/bluesoft/bee/releases/download/1.118/bee-1.118.zip"
  sha256 "de7bcc9cd1cb02d9017fd251b33c1e12a9dbb4cbbf7fe59f6d6cf3deb86708f5"
  license "MPL-1.1"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f08a87872d59ec4f386ae108b074921b78d836169a67e1bf3bad7b83cabca41b"
  end

  depends_on "openjdk"

  def install
    rm_r(Dir["bin/*.bat"])
    libexec.install Dir["*"]
    (bin/"bee").write_env_script libexec/"bin/bee", Language::Java.java_home_env
  end

  test do
    (testpath/"bee.properties").write <<~EOS
      test-database.driver=com.mysql.jdbc.Driver
      test-database.url=jdbc:mysql://127.0.0.1/test-database
      test-database.user=root
      test-database.password=
    EOS
    (testpath/"bee").mkpath
    system bin/"bee", "-d", testpath/"bee", "dbchange:create", "new-file"
  end
end