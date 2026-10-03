class Bee < Formula
  desc "Tool for managing database changes"
  homepage "https://github.com/bluesoft/bee"
  url "https://ghfast.top/https://github.com/bluesoft/bee/releases/download/1.116/bee-1.116.zip"
  sha256 "267681687d7d71fc741a32989500923d334162cb8aa925eae744d79486660a23"
  license "MPL-1.1"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b95dbdb100ff4cd33b426a9f583c486bab4da62db36efaf0af75b43bc3644e95"
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