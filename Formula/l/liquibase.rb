class Liquibase < Formula
  desc "Library for database change tracking"
  homepage "https:www.liquibase.org"
  url "https:github.comliquibaseliquibasereleasesdownloadv4.30.0liquibase-4.30.0.tar.gz"
  sha256 "184ffd609518091da42d6cd75e883b4f6ff1763cce8883e95fc99f7f05ca262d"
  license "Apache-2.0"

  livecheck do
    url "https:www.liquibase.comdownload"
    regex(href=.*?liquibase[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "606c75d13563d8e5047ddfd6471046f2340ac8bccf13dfa615807d1a4d35e61f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "606c75d13563d8e5047ddfd6471046f2340ac8bccf13dfa615807d1a4d35e61f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "606c75d13563d8e5047ddfd6471046f2340ac8bccf13dfa615807d1a4d35e61f"
    sha256 cellar: :any_skip_relocation, sonoma:        "084fbd7347d0735853ce3f6070cbfbef585de73c1eebd4cbdf9b88e8f4a86a31"
    sha256 cellar: :any_skip_relocation, ventura:       "084fbd7347d0735853ce3f6070cbfbef585de73c1eebd4cbdf9b88e8f4a86a31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "606c75d13563d8e5047ddfd6471046f2340ac8bccf13dfa615807d1a4d35e61f"
  end

  depends_on "openjdk"

  def install
    rm(Dir["*.bat"])

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
    system bin"liquibase", "--version"
  end
end