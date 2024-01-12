class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https:github.comdolthubdoltgresql"
  url "https:github.comdolthubdoltgresqlarchiverefstagsv0.3.1.tar.gz"
  sha256 "6d2458306755489f84ef6ac78bdf58f090511d2d3b099c3ff429a04daf4be024"
  license "Apache-2.0"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "21a1f239ffca8e97573e10471ec56088f727859af8f9c6e015453ceeec9bbe92"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd62afedc1f76949bdf60c45872432b5e3d5dad0f153d21ff63788a8d2196e7d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26af47e0356a650f4f245e8605cac543b488bb03b73536e963d6e0ebd75ab968"
    sha256 cellar: :any_skip_relocation, sonoma:         "44785896f19aa0d55779eabfdf57448fe3d8aa1149ce278e5b2ca223ec20b3d5"
    sha256 cellar: :any_skip_relocation, ventura:        "f002f7cc15b936a476c45f82466b2fc6e72792766ac8103a6d8e9fc5a41cf3a7"
    sha256 cellar: :any_skip_relocation, monterey:       "c217188deb9c48da5132bf19de220a5d7168851078e9ee2d76de2bb330a00edb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8117b800b306aed6c5a870c3e5ca17aa038aabd4aa39f742192ddcde84450e8"
  end

  depends_on "go" => :build
  depends_on "postgresql@16" => :test

  def install
    system ".postgresparserbuild.sh"
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    fork do
      exec bin"doltgres"
    end
    sleep 5
    psql = "#{Formula["postgresql@16"].opt_libexec}binpsql -h 127.0.0.1 -U doltgres -c 'SELECT DATABASE()'"
    assert_match "doltgres", shell_output(psql)
  end
end