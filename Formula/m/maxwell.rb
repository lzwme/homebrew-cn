class Maxwell < Formula
  desc "Reads MySQL binlogs and writes row updates as JSON to Kafka"
  homepage "https:maxwells-daemon.io"
  url "https:github.comzendeskmaxwellreleasesdownloadv1.42.0maxwell-1.42.0.tar.gz"
  sha256 "7624e95d42cbf4ff76c99b2ff7ba3f6664a90bd6296a82cc3b4fc055fc52eaeb"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "990392eb0fc2999456ca7586d3e0c6ccb777e1e490bfd6b0e306f1b68c114ac9"
  end

  depends_on "openjdk@11"

  def install
    libexec.install Dir["*"]

    %w[maxwell maxwell-bootstrap].each do |f|
      bin.install libexec"bin#{f}"
    end

    bin.env_script_all_files(libexec"bin", Language::Java.java_home_env("11.0"))
  end

  test do
    log = testpath"maxwell.log"

    fork do
      $stdout.reopen(log)
      $stderr.reopen(log)
      # Tell Maxwell to connect to a bogus host name so we don't actually connect to a local instance
      # The '.invalid' TLD is reserved as never to be installed as a valid TLD.
      exec "#{bin}maxwell --host not.real.invalid"
    end
    sleep 15

    # Validate that we actually got in to Maxwell far enough to attempt to connect.
    assert_match "CommunicationsException: Communications link failure", log.read
  end
end