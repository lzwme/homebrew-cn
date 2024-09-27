class Typedb < Formula
  desc "Strongly-typed database with a rich and logical type system"
  homepage "https:vaticle.com"
  url "https:github.comvaticletypedbreleasesdownload2.23.0typedb-all-mac-2.23.0.zip"
  sha256 "93a5540c02e3e4f4b7783a2d14a8907dcfde3c2b051984ca6b2df79abc3830ce"
  license "AGPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "dc3d91037b148bc7c232e2146eae539b52e328c6c76de01b137aa4639d6a6976"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    mkdir_p var"typedbdata"
    inreplace libexec"serverconfconfig.yml", "serverdata", var"typedbdata"
    mkdir_p var"typedblogs"
    inreplace libexec"serverconfconfig.yml", "serverlogs", var"typedblogs"
    bin.install libexec"typedb"
    bin.env_script_all_files(libexec, Language::Java.java_home_env)
  end

  test do
    assert_match "A STRONGLY-TYPED DATABASE", shell_output("#{bin}typedb server --help")
  end
end