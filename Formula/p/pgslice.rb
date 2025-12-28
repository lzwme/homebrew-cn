class Pgslice < Formula
  desc "Postgres partitioning as easy as pie"
  homepage "https://github.com/ankane/pgslice"
  url "https://ghfast.top/https://github.com/ankane/pgslice/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "9c4b597c376217f81b40775906a07d1a294f22236f357bc88551b4a3a67b6172"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b4b4be0e0a1b904fdf2f4e7070bbe4584d1f5c6ffc396d4adb1f2235ff929b09"
    sha256 cellar: :any,                 arm64_sequoia: "235fbcf25da6377e07285f0709b32c1d4072801d4658709c3153c271a4498df1"
    sha256 cellar: :any,                 arm64_sonoma:  "f81815ec0b91b0f5148540325ccb3cd023a1fe7225eecf60036c4fdbebccb3c7"
    sha256 cellar: :any,                 sonoma:        "cd3701c2c376c921e0983117e83fc3120870598323b47551e11b7f27c4eff7eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec2808ecc86a8937058214ec2cab7f2e683b8e8fa408457ecbce6994b91c53a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5007de865319d87c2b166c1efaef97c4fdeebbea3263adbc2f47b8fb6b72a410"
  end

  depends_on "postgresql@18" => :test
  depends_on "libpq"
  depends_on "ruby@3.4"

  # List with `gem install --explain pgslice -v #{version}`
  # https://rubygems.org/gems/pgslice/versions/#{version}/dependencies

  resource "thor" do
    url "https://rubygems.org/gems/thor-1.4.0.gem"
    sha256 "8763e822ccb0f1d7bee88cde131b19a65606657b847cc7b7b4b82e772bcd8a3d"
  end

  resource "pg" do
    url "https://rubygems.org/gems/pg-1.6.2.gem"
    sha256 "58614afd405cc9c2c9e15bffe8432e0d6cfc58b722344ad4a47c73a85189c875"
  end

  def install
    ENV["GEM_HOME"] = libexec
    ENV["PG_CONFIG"] = Formula["libpq"].opt_bin/"pg_config"

    resources.each do |r|
      r.fetch
      system "gem", "install", r.cached_download, "--ignore-dependencies",
             "--no-document", "--install-dir", libexec
    end

    system "gem", "build", "pgslice.gemspec"
    system "gem", "install", "--ignore-dependencies", "pgslice-#{version}.gem"

    bin.install libexec/"bin/pgslice"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    ENV["LC_ALL"] = "C"

    postgresql = Formula["postgresql@18"]
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test"
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"
      port = #{port}
    EOS
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"

    begin
      ENV["PGSLICE_URL"] = "postgres://localhost:#{port}/postgres"
      output = shell_output("#{bin}/pgslice prep users created_at day 2>&1", 1)
      assert_match "Table not found", output
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end