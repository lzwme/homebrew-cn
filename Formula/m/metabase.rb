class Metabase < Formula
  desc "Business intelligence report server"
  homepage "https://www.metabase.com/"
  url "https://downloads.metabase.com/v0.63.2/metabase.jar"
  sha256 "1cff5e2bb9507c667945b7ab164d8d5527316e6cd7cba8f6739d904c8c7e7a44"
  license "AGPL-3.0-only"

  # The first-party download page only provides an unversioned link to the
  # latest OSS jar file. We check the "latest" GitHub release, as the release
  # body text contains a versioned link to the OSS jar file.
  livecheck do
    url "https://github.com/metabase/metabase.git"
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e673478314c970ebfc0d8a1019b452e4bc0d9a4f842c7261b8a6b5c0341066a4"
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