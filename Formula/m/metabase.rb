class Metabase < Formula
  desc "Business intelligence report server"
  homepage "https://www.metabase.com/"
  url "https://downloads.metabase.com/v0.63.15/metabase.jar"
  sha256 "95268773d0eb8bef6ee0d57bc1dd6c352288e94279fdf85f0377be92c0f29c7f"
  license "AGPL-3.0-only"

  # The first-party download page only provides an unversioned link to the
  # latest OSS jar file. We check the "latest" GitHub release, as the release
  # body text contains a versioned link to the OSS jar file.
  livecheck do
    url "https://github.com/metabase/metabase.git"
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "eaac5fa916c81da0b43fef1e2ac7459737ad6ad524cbd93fffb7ffa9dba61c8e"
  end

  depends_on "openjdk"

  def install
    libexec.install "metabase.jar"
    bin.write_jar_script libexec/"metabase.jar", "metabase"
  end

  service do
    run opt_bin/"metabase"
    keep_alive true
    require_root true
    working_dir var/"metabase"
    log_path var/"metabase/server.log"
    error_log_path File::NULL
  end

  test do
    system bin/"metabase", "migrate", "up"
  end
end