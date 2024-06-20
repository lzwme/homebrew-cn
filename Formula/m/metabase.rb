class Metabase < Formula
  desc "Business intelligence report server"
  homepage "https:www.metabase.com"
  url "https:downloads.metabase.comv0.50.6metabase.jar"
  sha256 "3d7ad42870426be7cf9bbecc11b6847222c31e9a8f28703563a980538edecf29"
  license "AGPL-3.0-only"

  livecheck do
    url "https:www.metabase.comstartossjar.html"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)metabase\.jar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "280ba20dfec5052d1b7d56b7e0cff49b3f650c4bff7ab591d95499a2b6fda65e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "280ba20dfec5052d1b7d56b7e0cff49b3f650c4bff7ab591d95499a2b6fda65e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "280ba20dfec5052d1b7d56b7e0cff49b3f650c4bff7ab591d95499a2b6fda65e"
    sha256 cellar: :any_skip_relocation, sonoma:         "280ba20dfec5052d1b7d56b7e0cff49b3f650c4bff7ab591d95499a2b6fda65e"
    sha256 cellar: :any_skip_relocation, ventura:        "280ba20dfec5052d1b7d56b7e0cff49b3f650c4bff7ab591d95499a2b6fda65e"
    sha256 cellar: :any_skip_relocation, monterey:       "280ba20dfec5052d1b7d56b7e0cff49b3f650c4bff7ab591d95499a2b6fda65e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2809c14584a827650d57dc73bbfca02d02ad7f6600b5365ee6e00ba223de839e"
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