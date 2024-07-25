class Metabase < Formula
  desc "Business intelligence report server"
  homepage "https:www.metabase.com"
  url "https:downloads.metabase.comv0.50.15metabase.jar"
  sha256 "c42360d2b2b75b5457310b9883552e52ad0aaa21669b9493be083e2f61ccfa15"
  license "AGPL-3.0-only"

  livecheck do
    url "https:www.metabase.comstartossjar.html"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)metabase\.jar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "24c8db29421bcfc56d7dacf1bd5e4bd5ccc2484040396e99776a3a7438503aa5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24c8db29421bcfc56d7dacf1bd5e4bd5ccc2484040396e99776a3a7438503aa5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24c8db29421bcfc56d7dacf1bd5e4bd5ccc2484040396e99776a3a7438503aa5"
    sha256 cellar: :any_skip_relocation, sonoma:         "24c8db29421bcfc56d7dacf1bd5e4bd5ccc2484040396e99776a3a7438503aa5"
    sha256 cellar: :any_skip_relocation, ventura:        "24c8db29421bcfc56d7dacf1bd5e4bd5ccc2484040396e99776a3a7438503aa5"
    sha256 cellar: :any_skip_relocation, monterey:       "24c8db29421bcfc56d7dacf1bd5e4bd5ccc2484040396e99776a3a7438503aa5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b15b8d57fad77c910dea0abca105cac32cde01bb3cdcc261b5794b779fec5642"
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