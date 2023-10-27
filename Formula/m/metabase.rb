class Metabase < Formula
  desc "Business intelligence report server"
  homepage "https://www.metabase.com/"
  url "https://downloads.metabase.com/v0.47.6/metabase.jar"
  sha256 "2d617c3babf5c75897e5e242ba04359e82de509b15b6167b706bb25b7c3a5c68"
  license "AGPL-3.0-only"

  livecheck do
    url "https://www.metabase.com/start/oss/jar.html"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/metabase\.jar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "be3511a9b12e33438bbd290dca443ee6deb903639fea1f0074b8d0b62415e957"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be3511a9b12e33438bbd290dca443ee6deb903639fea1f0074b8d0b62415e957"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be3511a9b12e33438bbd290dca443ee6deb903639fea1f0074b8d0b62415e957"
    sha256 cellar: :any_skip_relocation, sonoma:         "be3511a9b12e33438bbd290dca443ee6deb903639fea1f0074b8d0b62415e957"
    sha256 cellar: :any_skip_relocation, ventura:        "be3511a9b12e33438bbd290dca443ee6deb903639fea1f0074b8d0b62415e957"
    sha256 cellar: :any_skip_relocation, monterey:       "be3511a9b12e33438bbd290dca443ee6deb903639fea1f0074b8d0b62415e957"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a399cf18833e168a18c96e3d2728bba3cdd28cc563abdd23d3c23cdc2199397"
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