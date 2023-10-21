class Metabase < Formula
  desc "Business intelligence report server"
  homepage "https://www.metabase.com/"
  url "https://downloads.metabase.com/v0.47.5/metabase.jar"
  sha256 "46ebdcf40b7a91d0774990495c7922003f661b52d6be6947d5aca93f58f40eb1"
  license "AGPL-3.0-only"

  livecheck do
    url "https://www.metabase.com/start/oss/jar.html"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/metabase\.jar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4ca1d4df9b09694f94da2bcfad060124bbdee2bd7029a4cd1ccbe01621089691"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ca1d4df9b09694f94da2bcfad060124bbdee2bd7029a4cd1ccbe01621089691"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ca1d4df9b09694f94da2bcfad060124bbdee2bd7029a4cd1ccbe01621089691"
    sha256 cellar: :any_skip_relocation, sonoma:         "4ca1d4df9b09694f94da2bcfad060124bbdee2bd7029a4cd1ccbe01621089691"
    sha256 cellar: :any_skip_relocation, ventura:        "4ca1d4df9b09694f94da2bcfad060124bbdee2bd7029a4cd1ccbe01621089691"
    sha256 cellar: :any_skip_relocation, monterey:       "4ca1d4df9b09694f94da2bcfad060124bbdee2bd7029a4cd1ccbe01621089691"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ab7383e6062006f2e356e4965cf72a03a46c35740ade8d6e8daf4236a80fe1e"
  end

  head do
    url "https://github.com/metabase/metabase.git", branch: "master"

    depends_on "leiningen" => :build
    depends_on "node" => :build
    depends_on "yarn" => :build
  end

  depends_on "openjdk"

  def install
    if build.head?
      system "./bin/build"
      libexec.install "target/uberjar/metabase.jar"
    else
      libexec.install "metabase.jar"
    end

    bin.write_jar_script libexec/"metabase.jar", "metabase"
  end

  service do
    run opt_bin/"metabase"
    keep_alive true
    require_root true
    working_dir var/"metabase"
    log_path var/"metabase/server.log"
    error_log_path "/dev/null"
  end

  test do
    system bin/"metabase", "migrate", "up"
  end
end