class Metabase < Formula
  desc "Business intelligence report server"
  homepage "https://www.metabase.com/"
  url "https://downloads.metabase.com/v0.46.0/metabase.jar"
  sha256 "2b8229fe53090b1239227db69da792e8cedf62240cd59bf99dbff629b37ac479"
  license "AGPL-3.0-only"

  livecheck do
    url "https://www.metabase.com/start/oss/jar.html"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/metabase\.jar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d04f3bd15fbae6555cf733ac55f1885bb0b7cba70d31359543a6fa94d89453b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d04f3bd15fbae6555cf733ac55f1885bb0b7cba70d31359543a6fa94d89453b8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d04f3bd15fbae6555cf733ac55f1885bb0b7cba70d31359543a6fa94d89453b8"
    sha256 cellar: :any_skip_relocation, ventura:        "d04f3bd15fbae6555cf733ac55f1885bb0b7cba70d31359543a6fa94d89453b8"
    sha256 cellar: :any_skip_relocation, monterey:       "d04f3bd15fbae6555cf733ac55f1885bb0b7cba70d31359543a6fa94d89453b8"
    sha256 cellar: :any_skip_relocation, big_sur:        "d04f3bd15fbae6555cf733ac55f1885bb0b7cba70d31359543a6fa94d89453b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "645119aa844c551751900191400e91763011e202c74e72d34fb1c57c27ea4f3d"
  end

  head do
    url "https://github.com/metabase/metabase.git", branch: "master"

    depends_on "leiningen" => :build
    depends_on "node" => :build
    depends_on "yarn" => :build
  end

  depends_on "openjdk"

  def install
    if build.head?
      system "./bin/build"
      libexec.install "target/uberjar/metabase.jar"
    else
      libexec.install "metabase.jar"
    end

    bin.write_jar_script libexec/"metabase.jar", "metabase"
  end

  service do
    run opt_bin/"metabase"
    keep_alive true
    require_root true
    working_dir var/"metabase"
    log_path var/"metabase/server.log"
    error_log_path "/dev/null"
  end

  test do
    system bin/"metabase", "migrate", "up"
  end
end