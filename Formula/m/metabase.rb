class Metabase < Formula
  desc "Business intelligence report server"
  homepage "https:www.metabase.com"
  url "https:downloads.metabase.comv0.50.16metabase.jar"
  sha256 "1a77ee1d8d3c4977a561875858e58e9a5e2427c3d5aa71276876dfc4acf3ab8e"
  license "AGPL-3.0-only"

  livecheck do
    url "https:www.metabase.comstartossjar.html"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)metabase\.jar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dcf613315d46a99b84a91b7a4db5a41ecb5f3bfb131dd764ff0f9deb76136eb9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dcf613315d46a99b84a91b7a4db5a41ecb5f3bfb131dd764ff0f9deb76136eb9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dcf613315d46a99b84a91b7a4db5a41ecb5f3bfb131dd764ff0f9deb76136eb9"
    sha256 cellar: :any_skip_relocation, sonoma:         "a8daae855f91d1abe926bc9d17cadc9ff2e3d1b5f19bd5bac2736b44a966b3b2"
    sha256 cellar: :any_skip_relocation, ventura:        "a8daae855f91d1abe926bc9d17cadc9ff2e3d1b5f19bd5bac2736b44a966b3b2"
    sha256 cellar: :any_skip_relocation, monterey:       "a8daae855f91d1abe926bc9d17cadc9ff2e3d1b5f19bd5bac2736b44a966b3b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b3c9bc296a4b2ae53586974278c28319a5c2ba5143a1adeda4e8a0dbae1af64"
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