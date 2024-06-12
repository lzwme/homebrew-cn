class Metabase < Formula
  desc "Business intelligence report server"
  homepage "https:www.metabase.com"
  url "https:downloads.metabase.comv0.50.0metabase.jar"
  sha256 "c8ab325c3be0cb921c55f9470e7e0b370edbea1018098c3412750591494c554b"
  license "AGPL-3.0-only"

  livecheck do
    url "https:www.metabase.comstartossjar.html"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)metabase\.jar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "966422b0f785c78bf7d4df6e23c14ab0643d222b1fbbf16a44996314d6966700"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "966422b0f785c78bf7d4df6e23c14ab0643d222b1fbbf16a44996314d6966700"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "966422b0f785c78bf7d4df6e23c14ab0643d222b1fbbf16a44996314d6966700"
    sha256 cellar: :any_skip_relocation, sonoma:         "966422b0f785c78bf7d4df6e23c14ab0643d222b1fbbf16a44996314d6966700"
    sha256 cellar: :any_skip_relocation, ventura:        "966422b0f785c78bf7d4df6e23c14ab0643d222b1fbbf16a44996314d6966700"
    sha256 cellar: :any_skip_relocation, monterey:       "966422b0f785c78bf7d4df6e23c14ab0643d222b1fbbf16a44996314d6966700"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2f2688e867e11e2afdc4146f96a88c9ccfea3964a6686b491a2f048cb78341b"
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