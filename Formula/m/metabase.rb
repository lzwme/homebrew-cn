class Metabase < Formula
  desc "Business intelligence report server"
  homepage "https://www.metabase.com/"
  url "https://downloads.metabase.com/v0.47.1/metabase.jar"
  sha256 "d86199ca8cac909198b16bffdf62e448bd17dc234e62c7540f66e654304b8327"
  license "AGPL-3.0-only"

  livecheck do
    url "https://www.metabase.com/start/oss/jar.html"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/metabase\.jar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "011f19438629fb777f5c3885cdf1a3dcb8a395a999d23c0fe5cee56b1d299f9b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "011f19438629fb777f5c3885cdf1a3dcb8a395a999d23c0fe5cee56b1d299f9b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "011f19438629fb777f5c3885cdf1a3dcb8a395a999d23c0fe5cee56b1d299f9b"
    sha256 cellar: :any_skip_relocation, ventura:        "011f19438629fb777f5c3885cdf1a3dcb8a395a999d23c0fe5cee56b1d299f9b"
    sha256 cellar: :any_skip_relocation, monterey:       "011f19438629fb777f5c3885cdf1a3dcb8a395a999d23c0fe5cee56b1d299f9b"
    sha256 cellar: :any_skip_relocation, big_sur:        "011f19438629fb777f5c3885cdf1a3dcb8a395a999d23c0fe5cee56b1d299f9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84a973aecbc17ada9da22a4a881b171a2802a281c5e60d21860885266d0528d8"
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