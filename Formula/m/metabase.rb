class Metabase < Formula
  desc "Business intelligence report server"
  homepage "https:www.metabase.com"
  url "https:downloads.metabase.comv0.50.17metabase.jar"
  sha256 "f8d8153dfe4e586de92a4be1ea0ce1ccdbaf45822fbf3d40a61aab5d98043bba"
  license "AGPL-3.0-only"

  livecheck do
    url "https:www.metabase.comstartossjar.html"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)metabase\.jar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b7e0c81f112c5e86ee1644f2174b3339b9f560e47c119ac696082c29075d5842"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7e0c81f112c5e86ee1644f2174b3339b9f560e47c119ac696082c29075d5842"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7e0c81f112c5e86ee1644f2174b3339b9f560e47c119ac696082c29075d5842"
    sha256 cellar: :any_skip_relocation, sonoma:         "b7e0c81f112c5e86ee1644f2174b3339b9f560e47c119ac696082c29075d5842"
    sha256 cellar: :any_skip_relocation, ventura:        "b7e0c81f112c5e86ee1644f2174b3339b9f560e47c119ac696082c29075d5842"
    sha256 cellar: :any_skip_relocation, monterey:       "b7e0c81f112c5e86ee1644f2174b3339b9f560e47c119ac696082c29075d5842"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a2545cb7aa8d03a11e11b21de332d207b755947fa2e2de2eb8257b9a6bc1923"
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
    error_log_path "devnull"
  end

  test do
    system bin"metabase", "migrate", "up"
  end
end