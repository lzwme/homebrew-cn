class Metabase < Formula
  desc "Business intelligence report server"
  homepage "https://www.metabase.com/"
  url "https://downloads.metabase.com/v0.46.6/metabase.jar"
  sha256 "8511069190e54d08cdd35dbf89333c2031eb5bbdb637ee20546b6c547e91e64a"
  license "AGPL-3.0-only"

  livecheck do
    url "https://www.metabase.com/start/oss/jar.html"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/metabase\.jar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f24d7154fa3712116eac60630e624f81851819f4efbc867df55a3d938dea9580"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f24d7154fa3712116eac60630e624f81851819f4efbc867df55a3d938dea9580"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f24d7154fa3712116eac60630e624f81851819f4efbc867df55a3d938dea9580"
    sha256 cellar: :any_skip_relocation, ventura:        "f24d7154fa3712116eac60630e624f81851819f4efbc867df55a3d938dea9580"
    sha256 cellar: :any_skip_relocation, monterey:       "f24d7154fa3712116eac60630e624f81851819f4efbc867df55a3d938dea9580"
    sha256 cellar: :any_skip_relocation, big_sur:        "f24d7154fa3712116eac60630e624f81851819f4efbc867df55a3d938dea9580"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13f1839d0a1703d2b82f5fb01f95e6b7fdcccdc0aedac4d02a1322861ad61f26"
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