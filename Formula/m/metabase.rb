class Metabase < Formula
  desc "Business intelligence report server"
  homepage "https:www.metabase.com"
  url "https:downloads.metabase.comv0.49.11metabase.jar"
  sha256 "b0b41d2238f66c1e0a79bc27d9f8ba9b0cf6cf29bf4afe65e36756033e43ac08"
  license "AGPL-3.0-only"

  livecheck do
    url "https:www.metabase.comstartossjar.html"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)metabase\.jar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1d82404e43e76e1ace6edc186a4445847fd8412ed1d3a99aeb0d419aba221d69"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6410857efae0b04b9fa7a86aa81e073bb935cb09953353da8441449ca85cf76b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "389defdc85df64a893e2e52864d877c02c67c9a22fb0a442635cb30941d5bea2"
    sha256 cellar: :any_skip_relocation, sonoma:         "a83bc6694af4620fc41b7783b9eba3cf5c285ff0307f93caca63747b2869e82d"
    sha256 cellar: :any_skip_relocation, ventura:        "f2a9e04776372cb7f2e6bf3f3686ae1816d1ff2abd4a16ba3d7107620a1bdc16"
    sha256 cellar: :any_skip_relocation, monterey:       "e8cde9a4a7db4cdd88676668e067b0d92bc7ccc7f8c1d85e9c720807c6f9876e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8359899af38aa2654aaecf72dc3524eadc38ceef904e7ae92ba8e93226fb5d62"
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