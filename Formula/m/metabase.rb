class Metabase < Formula
  desc "Business intelligence report server"
  homepage "https:www.metabase.com"
  url "https:downloads.metabase.comv0.50.18metabase.jar"
  sha256 "dbde70449b0a811fcbf2b8525934fbdc633dfee4523f40ddc7316a8f4d1b129c"
  license "AGPL-3.0-only"

  livecheck do
    url "https:www.metabase.comstartossjar.html"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)metabase\.jar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "42c60f820cc221ea6c54fa3dfbb7eb79ed03f8d22f1e3764785862a6e700c6bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "42c60f820cc221ea6c54fa3dfbb7eb79ed03f8d22f1e3764785862a6e700c6bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42c60f820cc221ea6c54fa3dfbb7eb79ed03f8d22f1e3764785862a6e700c6bc"
    sha256 cellar: :any_skip_relocation, sonoma:         "42c60f820cc221ea6c54fa3dfbb7eb79ed03f8d22f1e3764785862a6e700c6bc"
    sha256 cellar: :any_skip_relocation, ventura:        "42c60f820cc221ea6c54fa3dfbb7eb79ed03f8d22f1e3764785862a6e700c6bc"
    sha256 cellar: :any_skip_relocation, monterey:       "42c60f820cc221ea6c54fa3dfbb7eb79ed03f8d22f1e3764785862a6e700c6bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "369f8013cf95956b25897f1835e25bdd2321771c60dabb902f6d98af52395477"
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