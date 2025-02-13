class Metabase < Formula
  desc "Business intelligence report server"
  homepage "https:www.metabase.com"
  url "https:downloads.metabase.comv0.53.2metabase.jar"
  sha256 "b3d83922880fa538067af5fcca12f4b9af8ed7e96eda06939ff17c9f6a8c5677"
  license "AGPL-3.0-only"

  livecheck do
    url "https:www.metabase.comstartossjar.html"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)metabase\.jar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "914a0c4297f99f54a1e4ac2d6cf3123e841f167eba4ecffa6876cf605d06a9b6"
  end

  head do
    url "https:github.commetabasemetabase.git", branch: "master"

    depends_on "leiningen" => :build
    depends_on "node" => :build
    depends_on "yarn" => :build
  end

  depends_on "openjdk"

  def install
    if build.head?
      system ".binbuild"
      libexec.install "targetuberjarmetabase.jar"
    else
      libexec.install "metabase.jar"
    end

    bin.write_jar_script libexec"metabase.jar", "metabase"
  end

  service do
    run opt_bin"metabase"
    keep_alive true
    require_root true
    working_dir var"metabase"
    log_path var"metabaseserver.log"
    error_log_path File::NULL
  end

  test do
    system bin"metabase", "migrate", "up"
  end
end