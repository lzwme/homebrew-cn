class Bee < Formula
  desc "Tool for managing database changes"
  homepage "https:github.combluesoftbee"
  url "https:github.combluesoftbeereleasesdownload1.104bee-1.104.zip"
  sha256 "b0f1ab8daf944fcb80c85ec9939bf830dbb0aab9231c217e360a41ea012d12f2"
  license "MPL-1.1"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f726719c9db3a51e77179876090bcc9b8f99dce7c7921a96824e1da62d4da99c"
  end

  depends_on "openjdk"

  def install
    rm_r(Dir["bin*.bat"])
    libexec.install Dir["*"]
    (bin"bee").write_env_script libexec"binbee", Language::Java.java_home_env
  end

  test do
    (testpath"bee.properties").write <<~EOS
      test-database.driver=com.mysql.jdbc.Driver
      test-database.url=jdbc:mysql:127.0.0.1test-database
      test-database.user=root
      test-database.password=
    EOS
    (testpath"bee").mkpath
    system bin"bee", "-d", testpath"bee", "dbchange:create", "new-file"
  end
end