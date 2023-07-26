class Metabase < Formula
  desc "Business intelligence report server"
  homepage "https://www.metabase.com/"
  url "https://downloads.metabase.com/v0.46.6.2/metabase.jar"
  sha256 "924b6b70eb60caead478bbd725840770af75c323805da5a5461cc0ad0ea8562f"
  license "AGPL-3.0-only"

  livecheck do
    url "https://www.metabase.com/start/oss/jar.html"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/metabase\.jar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2effb4046f98ed1e89228a48464255de8e707de9dc8749fa03911bb41d8ea9a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2effb4046f98ed1e89228a48464255de8e707de9dc8749fa03911bb41d8ea9a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2effb4046f98ed1e89228a48464255de8e707de9dc8749fa03911bb41d8ea9a7"
    sha256 cellar: :any_skip_relocation, ventura:        "2effb4046f98ed1e89228a48464255de8e707de9dc8749fa03911bb41d8ea9a7"
    sha256 cellar: :any_skip_relocation, monterey:       "2effb4046f98ed1e89228a48464255de8e707de9dc8749fa03911bb41d8ea9a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "2effb4046f98ed1e89228a48464255de8e707de9dc8749fa03911bb41d8ea9a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3279f9aaf5fdf00b2ef0e39f03655d08ebcb11f289318a0f003504cf323f00a"
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