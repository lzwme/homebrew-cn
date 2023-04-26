class Typedb < Formula
  desc "Strongly-typed database with a rich and logical type system"
  homepage "https://vaticle.com/"
  url "https://ghproxy.com/https://github.com/vaticle/typedb/releases/download/2.17.0/typedb-all-mac-2.17.0.zip"
  sha256 "c11fe0f9b175dc4bbec06e3d6a515aeb62b2adb70bcfc9fe038351efa9900423"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f7366062f115d62aadde88364fb009189692df084f9fe50cfcacb870724ad011"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    mkdir_p var/"typedb/data"
    inreplace libexec/"server/conf/config.yml", "server/data", var/"typedb/data"
    mkdir_p var/"typedb/logs"
    inreplace libexec/"server/conf/config.yml", "server/logs", var/"typedb/logs"
    bin.install libexec/"typedb"
    bin.env_script_all_files(libexec, Language::Java.java_home_env)
  end

  test do
    assert_match "A STRONGLY-TYPED DATABASE", shell_output("#{bin}/typedb server --help")
  end
end