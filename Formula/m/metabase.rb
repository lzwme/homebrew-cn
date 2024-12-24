class Metabase < Formula
  desc "Business intelligence report server"
  homepage "https:www.metabase.com"
  url "https:downloads.metabase.comv0.52.4metabase.jar"
  sha256 "b03961f3687b2dea982b11b4822d5c47864230389ce49d673f004f43de7c48b6"
  license "AGPL-3.0-only"

  livecheck do
    url "https:www.metabase.comstartossjar.html"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)metabase\.jar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9c1b59132401472ad8f657a8917e4ff704b29e4f3f11b131f39e240c7a86feb5"
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