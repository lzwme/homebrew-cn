class Wal2json < Formula
  desc "Convert PostgreSQL changesets to JSON format"
  homepage "https:github.comeulertowal2json"
  url "https:github.comeulertowal2jsonarchiverefstagswal2json_2_5.tar.gz"
  sha256 "b516653575541cf221b99cf3f8be9b6821f6dbcfc125675c85f35090f824f00e"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex((?:wal2json[._-])?v?(\d+(?:[._]\d+)+)i)
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5faacc982f916c821ef15a80a29d693b51767493b7cc59d484df1edb3592198a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e6efe36aa934e9d6632665735092759dab9fea62bd61f58d76a562e11fee07f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c9fb98103a31164cd0938c985f80d4dfa297d271b3d1a743d940984a909a4b2"
    sha256 cellar: :any_skip_relocation, sonoma:         "9b84d61db182c63e456d9aeb4e92a316a296d631a4511d289bf91ca8d2e22a3a"
    sha256 cellar: :any_skip_relocation, ventura:        "2c699e3aa0e2866658d16dd8b6a2500cdaeb6ec3d046e4511846a9660c79193d"
    sha256 cellar: :any_skip_relocation, monterey:       "a7006c22c3c03db8d8c83bf9df20630d35076093907e27c93e1b2fefff84b410"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8251e42a8bac872bc7c5b596fa500d029f124ac7808904da05807e8ee35b33b"
  end

  depends_on "postgresql@16"

  def postgresql
    Formula["postgresql@16"]
  end

  def install
    system "make", "install", "USE_PGXS=1",
                              "PG_CONFIG=#{postgresql.opt_libexec}binpg_config",
                              "pkglibdir=#{libpostgresql.name}"
  end

  test do
    ENV["LC_ALL"] = "C"
    pg_ctl = postgresql.opt_libexec"binpg_ctl"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath"test"
    (testpath"testpostgresql.conf").write <<~EOS, mode: "a+"

      shared_preload_libraries = 'wal2json'
      port = #{port}
    EOS
    system pg_ctl, "start", "-D", testpath"test", "-l", testpath"log"
    system pg_ctl, "stop", "-D", testpath"test"
  end
end