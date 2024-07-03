class Metabase < Formula
  desc "Business intelligence report server"
  homepage "https:www.metabase.com"
  url "https:downloads.metabase.comv0.50.9metabase.jar"
  sha256 "c6e2a5d88e9e5395baf38d9221251f9b50d2f9cba30842907eb7291d64dd0068"
  license "AGPL-3.0-only"

  livecheck do
    url "https:www.metabase.comstartossjar.html"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)metabase\.jar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0edf01c40b900e7db54d301bacd4ed8759808bab2ed247e0069dc86afd7ee157"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0edf01c40b900e7db54d301bacd4ed8759808bab2ed247e0069dc86afd7ee157"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0edf01c40b900e7db54d301bacd4ed8759808bab2ed247e0069dc86afd7ee157"
    sha256 cellar: :any_skip_relocation, sonoma:         "0edf01c40b900e7db54d301bacd4ed8759808bab2ed247e0069dc86afd7ee157"
    sha256 cellar: :any_skip_relocation, ventura:        "0edf01c40b900e7db54d301bacd4ed8759808bab2ed247e0069dc86afd7ee157"
    sha256 cellar: :any_skip_relocation, monterey:       "0edf01c40b900e7db54d301bacd4ed8759808bab2ed247e0069dc86afd7ee157"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c963fb022f26396d997ae6c68a1c8f0e0088e489a16dd9e69cd40765bcce9206"
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