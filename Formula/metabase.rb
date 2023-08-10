class Metabase < Formula
  desc "Business intelligence report server"
  homepage "https://www.metabase.com/"
  url "https://downloads.metabase.com/v0.46.7/metabase.jar"
  sha256 "2c6b63cce0d59283abf3219c13e7e980ccc83501b79417214ee8d3b191a00115"
  license "AGPL-3.0-only"

  livecheck do
    url "https://www.metabase.com/start/oss/jar.html"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/metabase\.jar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "141292264542b0e23e1e7d52995ceaeb66457383b9643f3dd73c9c9a70e07c74"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "141292264542b0e23e1e7d52995ceaeb66457383b9643f3dd73c9c9a70e07c74"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "141292264542b0e23e1e7d52995ceaeb66457383b9643f3dd73c9c9a70e07c74"
    sha256 cellar: :any_skip_relocation, ventura:        "141292264542b0e23e1e7d52995ceaeb66457383b9643f3dd73c9c9a70e07c74"
    sha256 cellar: :any_skip_relocation, monterey:       "141292264542b0e23e1e7d52995ceaeb66457383b9643f3dd73c9c9a70e07c74"
    sha256 cellar: :any_skip_relocation, big_sur:        "141292264542b0e23e1e7d52995ceaeb66457383b9643f3dd73c9c9a70e07c74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa414982c8077eb1e146d22192378eb375c247091fa6b3c1378258334eae648f"
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