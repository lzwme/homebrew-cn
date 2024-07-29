class Liquibase < Formula
  desc "Library for database change tracking"
  homepage "https:www.liquibase.org"
  url "https:github.comliquibaseliquibasereleasesdownloadv4.29.0liquibase-4.29.0.tar.gz"
  sha256 "0883b4975fc2f0a2f0180614cb156cea3c453057e6ec185c01550ec67030d8d0"
  license "Apache-2.0"

  livecheck do
    url "https:www.liquibase.comdownload"
    regex(href=.*?liquibase[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dced62484546cdd3490da1388037fbf7c3f6bb39f8c3ebf2f885d6e462b462e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dced62484546cdd3490da1388037fbf7c3f6bb39f8c3ebf2f885d6e462b462e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dced62484546cdd3490da1388037fbf7c3f6bb39f8c3ebf2f885d6e462b462e0"
    sha256 cellar: :any_skip_relocation, sonoma:         "b4d7c2c822577889d00ebaa14634bc4845e24ee1fe6e705f6d70678e277daaac"
    sha256 cellar: :any_skip_relocation, ventura:        "b4d7c2c822577889d00ebaa14634bc4845e24ee1fe6e705f6d70678e277daaac"
    sha256 cellar: :any_skip_relocation, monterey:       "b4d7c2c822577889d00ebaa14634bc4845e24ee1fe6e705f6d70678e277daaac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29fb647987769104961ecaf9a4ddccd4351a7e5754ac5a99bacbcca83d39112c"
  end

  depends_on "openjdk"

  def install
    rm_f Dir["*.bat"]

    chmod 0755, "liquibase"
    libexec.install Dir["*"]
    (bin"liquibase").write_env_script libexec"liquibase", Language::Java.overridable_java_home_env
    (libexec"lib").install_symlink Dir["#{libexec}sdklib-sdkslf4j*"]
  end

  def caveats
    <<~EOS
      You should set the environment variable LIQUIBASE_HOME to
        #{opt_libexec}
    EOS
  end

  test do
    system "#{bin}liquibase", "--version"
  end
end