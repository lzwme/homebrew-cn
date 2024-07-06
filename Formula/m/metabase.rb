class Metabase < Formula
  desc "Business intelligence report server"
  homepage "https:www.metabase.com"
  url "https:downloads.metabase.comv0.50.10metabase.jar"
  sha256 "6dd9c3ee5228deaf23228d26e8ec741d6b03c98b697ce9cdaa13db6a47775f98"
  license "AGPL-3.0-only"

  livecheck do
    url "https:www.metabase.comstartossjar.html"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)metabase\.jar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e9de2ddbf2bd6464277696c6b0676867fe5e515d2c86aef26665378112a0824f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9de2ddbf2bd6464277696c6b0676867fe5e515d2c86aef26665378112a0824f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9de2ddbf2bd6464277696c6b0676867fe5e515d2c86aef26665378112a0824f"
    sha256 cellar: :any_skip_relocation, sonoma:         "e9de2ddbf2bd6464277696c6b0676867fe5e515d2c86aef26665378112a0824f"
    sha256 cellar: :any_skip_relocation, ventura:        "e9de2ddbf2bd6464277696c6b0676867fe5e515d2c86aef26665378112a0824f"
    sha256 cellar: :any_skip_relocation, monterey:       "e9de2ddbf2bd6464277696c6b0676867fe5e515d2c86aef26665378112a0824f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc153716a86cae13a38a4cf44d7e60ffeecc677fcd232befc2b086d652d6915f"
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