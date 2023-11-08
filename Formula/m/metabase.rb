class Metabase < Formula
  desc "Business intelligence report server"
  homepage "https://www.metabase.com/"
  url "https://downloads.metabase.com/v0.47.7/metabase.jar"
  sha256 "522c709653b06531e7689abce1236a5ca70164f1541a5665900add80a804685e"
  license "AGPL-3.0-only"

  livecheck do
    url "https://www.metabase.com/start/oss/jar.html"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/metabase\.jar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2e92ebb1c42a6e4155020a27de1c648563fd145fe9b027e253f7bd5a9b699924"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e92ebb1c42a6e4155020a27de1c648563fd145fe9b027e253f7bd5a9b699924"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e92ebb1c42a6e4155020a27de1c648563fd145fe9b027e253f7bd5a9b699924"
    sha256 cellar: :any_skip_relocation, sonoma:         "2e92ebb1c42a6e4155020a27de1c648563fd145fe9b027e253f7bd5a9b699924"
    sha256 cellar: :any_skip_relocation, ventura:        "2e92ebb1c42a6e4155020a27de1c648563fd145fe9b027e253f7bd5a9b699924"
    sha256 cellar: :any_skip_relocation, monterey:       "2e92ebb1c42a6e4155020a27de1c648563fd145fe9b027e253f7bd5a9b699924"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4459f1f1242a5e566ff5ddbd4134fa155162cb2be5c87c0fbc170b012fb0b5b3"
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