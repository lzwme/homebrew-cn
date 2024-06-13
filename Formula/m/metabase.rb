class Metabase < Formula
  desc "Business intelligence report server"
  homepage "https:www.metabase.com"
  url "https:downloads.metabase.comv0.50.1metabase.jar"
  sha256 "6804be983500fdc535095b40ac4d7986b31d34824fc47635d09e32096deaf495"
  license "AGPL-3.0-only"

  livecheck do
    url "https:www.metabase.comstartossjar.html"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)metabase\.jar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c1b369489da225a82271565b9b82358f41b17bb3f0cae11fa70e406616af160d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1b369489da225a82271565b9b82358f41b17bb3f0cae11fa70e406616af160d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e23584d91d55e9db1ca4fcf2d8938539533def4c09a6e453a1b0af37f3f6d67"
    sha256 cellar: :any_skip_relocation, sonoma:         "0f7389d4b35ed506c458ebd1341367e371197a407cd509277ce2208794a128b1"
    sha256 cellar: :any_skip_relocation, ventura:        "0f7389d4b35ed506c458ebd1341367e371197a407cd509277ce2208794a128b1"
    sha256 cellar: :any_skip_relocation, monterey:       "c1b369489da225a82271565b9b82358f41b17bb3f0cae11fa70e406616af160d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0f2f99738af82f15c01deaf299518d5a77da9f69c4649fdc31258bfe3b3838d"
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