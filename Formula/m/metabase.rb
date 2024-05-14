class Metabase < Formula
  desc "Business intelligence report server"
  homepage "https:www.metabase.com"
  url "https:downloads.metabase.comv0.49.10metabase.jar"
  sha256 "08509b49d2eb3a48775958c339dea98542989735e20258a64f537b5faa996ffb"
  license "AGPL-3.0-only"

  livecheck do
    url "https:www.metabase.comstartossjar.html"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)metabase\.jar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f2ae741746ae1954254f840b99e6bc18c92539cbf5fc405d78fdcdb0bc4a06c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e5cf415bcb6444979ca20c7e24dd2b0e3761896c29e9cb9a6fe226042a568048"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b8de70a704942e53b3770374b3f0073983a390465637bedcfb339e54aa4a911"
    sha256 cellar: :any_skip_relocation, sonoma:         "56c087a7058fc14d51653b4979c18239b1148baa63643ae9d5ab8fe552a9929a"
    sha256 cellar: :any_skip_relocation, ventura:        "7fdc98a3be93f8174830ec4e3913bb445755fa27e763a673f13caebbdef9ce5a"
    sha256 cellar: :any_skip_relocation, monterey:       "5ddc0d91f4d76454e3a9ef4651348dd82c5547abfe549299d3a7abbedfcb9e60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d92d80f8cdbd72a3d288d643932b9c4eb213f146d812326293529b21fc6b99f"
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