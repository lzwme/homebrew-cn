class Metabase < Formula
  desc "Business intelligence report server"
  homepage "https://www.metabase.com/"
  url "https://downloads.metabase.com/v0.46.6.4/metabase.jar"
  sha256 "0a6176e85cb143fe1e55fd990216bfb1fff97941eaa3df3a29d9231d2b0a2d24"
  license "AGPL-3.0-only"

  livecheck do
    url "https://www.metabase.com/start/oss/jar.html"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/metabase\.jar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b0d6a6af4555b4df99869e64b002c9fa77e03b39ea2ebe19040b74b94661e4fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0d6a6af4555b4df99869e64b002c9fa77e03b39ea2ebe19040b74b94661e4fe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b0d6a6af4555b4df99869e64b002c9fa77e03b39ea2ebe19040b74b94661e4fe"
    sha256 cellar: :any_skip_relocation, ventura:        "b0d6a6af4555b4df99869e64b002c9fa77e03b39ea2ebe19040b74b94661e4fe"
    sha256 cellar: :any_skip_relocation, monterey:       "b0d6a6af4555b4df99869e64b002c9fa77e03b39ea2ebe19040b74b94661e4fe"
    sha256 cellar: :any_skip_relocation, big_sur:        "b0d6a6af4555b4df99869e64b002c9fa77e03b39ea2ebe19040b74b94661e4fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a6af1321276cc3846fe6605fb898f175c6e0e1fd0b4364b393dd6a6c94e1a48"
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