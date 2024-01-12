class Dexter < Formula
  desc "Automatic indexer for Postgres"
  homepage "https:github.comankanedexter"
  url "https:github.comankanedexterarchiverefstagsv0.5.2.tar.gz"
  sha256 "78773d4d75fdba34843c89a49d4d91f8f3496752308005d965153586a091f64e"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "d05b0835f1ea35d41e1e9e71137bdaefab4c5e9ba27efe364ff7db8f21682ce5"
    sha256 cellar: :any,                 arm64_ventura:  "3c89ad78d7b1d8fed33f2c6db363118bf095aee765f5feed1413bfb7bbc5116e"
    sha256 cellar: :any,                 arm64_monterey: "c0b91f8616fb308ffb510102ce93b9fc884aef6f6d0fe95db1fcc691a989adfa"
    sha256 cellar: :any,                 sonoma:         "70ce71bbae22816ba6795dadba6d9047df7d6b0fa9728f1ab21abcb2dc572cf9"
    sha256 cellar: :any,                 ventura:        "91d93539ee2b2b7fc5f3d00ad7478b0aba0c8832d3f7096b0613c1ee5099affd"
    sha256 cellar: :any,                 monterey:       "99a92796eadb4ae34fc5cd1fc3d553bea4d41f9f66af6e29fb80c675f72c0d4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30b8e8c150b578bbfca9e85ca3f0f6e620cb8563bdd16e988e0bf895ee6d871f"
  end

  depends_on "postgresql@16" => :test
  depends_on "libpq"
  depends_on "ruby"

  resource "google-protobuf" do
    url "https:rubygems.orggemsgoogle-protobuf-3.25.2.gem"
    sha256 "9c2e6121d768f812f50b78cb6f26056f2af6bab92af793d376b772126e26500b"
  end

  resource "pg" do
    url "https:rubygems.orggemspg-1.5.4.gem"
    sha256 "04f7b247151c639a0b955d8e5a9a41541343f4640aa3c2bdf749a872c339d25d"
  end

  resource "pg_query" do
    url "https:rubygems.orggemspg_query-4.2.3.gem"
    sha256 "1cc9955c7bce8e51e1abc11f1952e3d9d0f1cd4c16c58c56ec75d5aaf1cfd697"
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

    postgresql = Formula["postgresql@16"]
    pg_ctl = postgresql.opt_libexec"binpg_ctl"
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