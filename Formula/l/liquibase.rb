class Liquibase < Formula
  desc "Library for database change tracking"
  homepage "https://www.liquibase.org/"
  url "https://ghproxy.com/https://github.com/liquibase/liquibase/releases/download/v4.25.0/liquibase-4.25.0.tar.gz"
  sha256 "362174965cd8c2c74f1026201f911afc1a323c822828bf3fd04bcefa3aa45c49"
  license "Apache-2.0"

  livecheck do
    url "https://www.liquibase.com/download"
    regex(/href=.*?liquibase[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc1898ae30a51d99b7f8da0c5fbf2bcdbfdeda2b04f263da809515f528e1384f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc1898ae30a51d99b7f8da0c5fbf2bcdbfdeda2b04f263da809515f528e1384f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc1898ae30a51d99b7f8da0c5fbf2bcdbfdeda2b04f263da809515f528e1384f"
    sha256 cellar: :any_skip_relocation, sonoma:         "e971f5810b861bf2bf0b182bd3b8abbff8d5c2fb6611ff4e9b5c358143826aa4"
    sha256 cellar: :any_skip_relocation, ventura:        "e971f5810b861bf2bf0b182bd3b8abbff8d5c2fb6611ff4e9b5c358143826aa4"
    sha256 cellar: :any_skip_relocation, monterey:       "e971f5810b861bf2bf0b182bd3b8abbff8d5c2fb6611ff4e9b5c358143826aa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc1898ae30a51d99b7f8da0c5fbf2bcdbfdeda2b04f263da809515f528e1384f"
  end

  depends_on "openjdk"

  def install
    rm_f Dir["*.bat"]
    chmod 0755, "liquibase"
    prefix.install_metafiles
    libexec.install Dir["*"]
    (bin/"liquibase").write_env_script libexec/"liquibase", Language::Java.overridable_java_home_env
    (libexec/"lib").install_symlink Dir["#{libexec}/sdk/lib-sdk/slf4j*"]
  end

  def caveats
    <<~EOS
      You should set the environment variable LIQUIBASE_HOME to
        #{opt_libexec}
    EOS
  end

  test do
    system "#{bin}/liquibase", "--version"
  end
end