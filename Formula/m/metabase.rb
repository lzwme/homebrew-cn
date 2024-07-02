class Metabase < Formula
  desc "Business intelligence report server"
  homepage "https:www.metabase.com"
  url "https:downloads.metabase.comv0.50.8metabase.jar"
  sha256 "674c6f53c653f5a5ded0d294861df4d97ad6c113a59084475a0723c332ccafc4"
  license "AGPL-3.0-only"

  livecheck do
    url "https:www.metabase.comstartossjar.html"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)metabase\.jar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6b6d507b740120f7cf4a457f1c302309fc23d58f2e866c45cb6faa109096bf0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b6d507b740120f7cf4a457f1c302309fc23d58f2e866c45cb6faa109096bf0b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b6d507b740120f7cf4a457f1c302309fc23d58f2e866c45cb6faa109096bf0b"
    sha256 cellar: :any_skip_relocation, sonoma:         "6b6d507b740120f7cf4a457f1c302309fc23d58f2e866c45cb6faa109096bf0b"
    sha256 cellar: :any_skip_relocation, ventura:        "6b6d507b740120f7cf4a457f1c302309fc23d58f2e866c45cb6faa109096bf0b"
    sha256 cellar: :any_skip_relocation, monterey:       "6b6d507b740120f7cf4a457f1c302309fc23d58f2e866c45cb6faa109096bf0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8958109a60353e578057fb00322de63859e5689d14861d947a230f2d49891564"
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