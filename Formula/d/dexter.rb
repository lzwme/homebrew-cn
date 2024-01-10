class Dexter < Formula
  desc "Automatic indexer for Postgres"
  homepage "https:github.comankanedexter"
  url "https:github.comankanedexterarchiverefstagsv0.5.1.tar.gz"
  sha256 "280403858ea209b41910f487f737fd602b41c60cc6cd3e5cf54ed5db9330b321"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "be94f7b338b28ed362c82b4b8d731ebfb3f6fd175fc98e8c7514d08583528406"
    sha256 cellar: :any,                 arm64_ventura:  "0719f4b0bb7bec319be9f86e7d22e2b0cdadbdb5473c9f76c4bd83e52bcf4897"
    sha256 cellar: :any,                 arm64_monterey: "21a8e91c98e3415a386c4c41b16289c77bd4233d1c2b5d4185754a5822fa8296"
    sha256 cellar: :any,                 sonoma:         "f4613aeaae43ac94f982465e783219f6c8329010c1821de3c8ac13c8c5557c36"
    sha256 cellar: :any,                 ventura:        "996d8f071db725f9634f0fc9282cc1dde56e4c251e9f5ac20b0859f184fbec43"
    sha256 cellar: :any,                 monterey:       "6f68fb77b162801b0dd5b6ff872207db7145994bb1cc4fa57acaf558ce740518"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81868f9315ef4a076f205b3876385b98175a728b67985142a9dc6f5ee4b43026"
  end

  depends_on "postgresql@15" => :test
  depends_on "libpq"
  depends_on "ruby"

  resource "google-protobuf" do
    url "https:rubygems.orggemsgoogle-protobuf-3.23.2.gem"
    sha256 "499ac76d22e86a050e3743a4ca332c84eb5a501a29079849f15c6dfecdbcd00f"
  end

  resource "pg" do
    url "https:rubygems.orggemspg-1.5.3.gem"
    sha256 "6b9ee5e2d5aee975588232c41f8203e766157cf71dba54ee85b343a45ced9bfd"
  end

  resource "pg_query" do
    url "https:rubygems.orggemspg_query-4.2.1.gem"
    sha256 "b04820a9d1c0c1608e3240b7d84baabbee1b95a7302f29fdd0f00e901c604833"
  end

  resource "slop" do
    url "https:rubygems.orggemsslop-4.10.1.gem"
    sha256 "844322b5ffcf17ed4815fdb173b04a20dd82b4fd93e3744c88c8fafea696d9c7"
  end

  def install
    ENV["GEM_HOME"] = libexec
    ENV["PG_CONFIG"] = Formula["libpq"].opt_bin"pg_config"

    resources.each do |r|
      r.fetch
      system "gem", "install", r.cached_download, "--ignore-dependencies",
             "--no-document", "--install-dir", libexec
    end

    system "gem", "build", "pgdexter.gemspec"
    system "gem", "install", "--ignore-dependencies", "pgdexter-#{version}.gem"

    bin.install libexec"bindexter"
    bin.env_script_all_files(libexec"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    ENV["LC_ALL"] = "C"

    postgresql = Formula["postgresql@15"]
    pg_ctl = postgresql.opt_bin"pg_ctl"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath"test"
    (testpath"testpostgresql.conf").write <<~EOS, mode: "a+"
      port = #{port}
    EOS
    system pg_ctl, "start", "-D", testpath"test", "-l", testpath"log"

    begin
      output = shell_output("#{bin}dexter -d postgres -p #{port} -s SELECT 1 2>&1", 1)
      assert_match "Install HypoPG", output
    ensure
      system pg_ctl, "stop", "-D", testpath"test"
    end
  end
end