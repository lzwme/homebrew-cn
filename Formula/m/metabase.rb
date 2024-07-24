class Metabase < Formula
  desc "Business intelligence report server"
  homepage "https:www.metabase.com"
  url "https:downloads.metabase.comv0.50.14metabase.jar"
  sha256 "084e0168d340abc09647e9012e3c32e6ee6b56d7d8d583fabb01e5b0130ca2a8"
  license "AGPL-3.0-only"

  livecheck do
    url "https:www.metabase.comstartossjar.html"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)metabase\.jar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7c817f30789521ccaeef37bfdf040947bc51bffec083c6327214624f5725544e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c817f30789521ccaeef37bfdf040947bc51bffec083c6327214624f5725544e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c817f30789521ccaeef37bfdf040947bc51bffec083c6327214624f5725544e"
    sha256 cellar: :any_skip_relocation, sonoma:         "31d656cac4ebf54d02c4e362e1dc29e6d657f9197539088aab40c5a755bfa5cb"
    sha256 cellar: :any_skip_relocation, ventura:        "31d656cac4ebf54d02c4e362e1dc29e6d657f9197539088aab40c5a755bfa5cb"
    sha256 cellar: :any_skip_relocation, monterey:       "7c817f30789521ccaeef37bfdf040947bc51bffec083c6327214624f5725544e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c333c794a14c67d134241a9a4a78b3bcd046685a8479b9b9d77ea88692c7802"
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