class Metabase < Formula
  desc "Business intelligence report server"
  homepage "https:www.metabase.com"
  url "https:downloads.metabase.comv0.53.8metabase.jar"
  sha256 "39795c1a3db9737962d91d74e23369b9bbd02a04f62afd14c5fe33b1171e5358"
  license "AGPL-3.0-only"

  livecheck do
    url "https:www.metabase.comstartossjar.html"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)metabase\.jar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d91c79503693e6fb73f4b267d2a483ffa9c3215a1675552a959516427ab62ec0"
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