class Metabase < Formula
  desc "Business intelligence report server"
  homepage "https:www.metabase.com"
  url "https:downloads.metabase.comv0.50.3metabase.jar"
  sha256 "def3903f275276e339f2ed99bb37fd2f85652b62f8f3be50cb0e708f1eeaffbc"
  license "AGPL-3.0-only"

  livecheck do
    url "https:www.metabase.comstartossjar.html"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)metabase\.jar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6ec828b1af5ff8a965b76fe6787256da936f33149f0381ce1e80234b34a8416b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ec828b1af5ff8a965b76fe6787256da936f33149f0381ce1e80234b34a8416b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ec828b1af5ff8a965b76fe6787256da936f33149f0381ce1e80234b34a8416b"
    sha256 cellar: :any_skip_relocation, sonoma:         "6ec828b1af5ff8a965b76fe6787256da936f33149f0381ce1e80234b34a8416b"
    sha256 cellar: :any_skip_relocation, ventura:        "6ec828b1af5ff8a965b76fe6787256da936f33149f0381ce1e80234b34a8416b"
    sha256 cellar: :any_skip_relocation, monterey:       "6ec828b1af5ff8a965b76fe6787256da936f33149f0381ce1e80234b34a8416b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb51aa22e4fb5dbd8404203ad26782c201817799d5e2ce9552a76ee349e7585d"
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