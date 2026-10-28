class Metabase < Formula
  desc "Business intelligence report server"
  homepage "https://www.metabase.com/"
  url "https://downloads.metabase.com/v0.64.3/metabase.jar"
  sha256 "884eafd40d81144fabd8846e33d5f6135536b2e4ff9076eef397e7ce2cdb08b9"
  license "AGPL-3.0-only"

  # The first-party download page only provides an unversioned link to the
  # latest OSS jar file. We check the "latest" GitHub release, as the release
  # body text contains a versioned link to the OSS jar file.
  livecheck do
    url "https://github.com/metabase/metabase.git"
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "09aa65c8a16bc9ad9e6a27c7b4eb80bb62e57804dc0c1741426075ba230114be"
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