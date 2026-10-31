class Metabase < Formula
  desc "Business intelligence report server"
  homepage "https://www.metabase.com/"
  url "https://downloads.metabase.com/v0.65.2/metabase.jar"
  sha256 "257b1d5170d8b0c1dd46f29c2a0a2f3b6434ed58d15cac67a08eb8cd7dbefaad"
  license "AGPL-3.0-only"

  # The first-party download page only provides an unversioned link to the
  # latest OSS jar file. We check the "latest" GitHub release, as the release
  # body text contains a versioned link to the OSS jar file.
  livecheck do
    url "https://github.com/metabase/metabase.git"
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a77dba62231bb57e1a437e32bf608f462c470ef3af52b00b3510586013ffb15b"
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