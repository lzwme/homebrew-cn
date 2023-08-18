class Metabase < Formula
  desc "Business intelligence report server"
  homepage "https://www.metabase.com/"
  url "https://downloads.metabase.com/v0.47.0/metabase.jar"
  sha256 "9bf03a464163971196bec306590041e8f571f24e1d5a34695363f0dea1eba809"
  license "AGPL-3.0-only"

  livecheck do
    url "https://www.metabase.com/start/oss/jar.html"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/metabase\.jar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ca0160169bd726debf09886f280dacb70548298c57301afbbff4605e9337cc5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ca0160169bd726debf09886f280dacb70548298c57301afbbff4605e9337cc5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ca0160169bd726debf09886f280dacb70548298c57301afbbff4605e9337cc5"
    sha256 cellar: :any_skip_relocation, ventura:        "1ca0160169bd726debf09886f280dacb70548298c57301afbbff4605e9337cc5"
    sha256 cellar: :any_skip_relocation, monterey:       "1ca0160169bd726debf09886f280dacb70548298c57301afbbff4605e9337cc5"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ca0160169bd726debf09886f280dacb70548298c57301afbbff4605e9337cc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aee449ec71fa6e129bfc75f774aca679cd1b3d4680a27889dd20cfcdf3f327ca"
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