class Metabase < Formula
  desc "Business intelligence report server"
  homepage "https://www.metabase.com/"
  url "https://downloads.metabase.com/v0.46.2/metabase.jar"
  sha256 "14723c4146483cc84134e77445f7522869082da4654b885ef04552ad0c630f4b"
  license "AGPL-3.0-only"

  livecheck do
    url "https://www.metabase.com/start/oss/jar.html"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/metabase\.jar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "414ee76d35ea0b53385aab444612ce383a95dae41c68da308ac53443d57d4a5a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "414ee76d35ea0b53385aab444612ce383a95dae41c68da308ac53443d57d4a5a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "414ee76d35ea0b53385aab444612ce383a95dae41c68da308ac53443d57d4a5a"
    sha256 cellar: :any_skip_relocation, ventura:        "414ee76d35ea0b53385aab444612ce383a95dae41c68da308ac53443d57d4a5a"
    sha256 cellar: :any_skip_relocation, monterey:       "414ee76d35ea0b53385aab444612ce383a95dae41c68da308ac53443d57d4a5a"
    sha256 cellar: :any_skip_relocation, big_sur:        "414ee76d35ea0b53385aab444612ce383a95dae41c68da308ac53443d57d4a5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c1b4ae6e4a11fc7408ddfa667dc3d080559d3bd8de2a07497aa64d9e7d4afd2"
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