class Mmdbctl < Formula
  desc "MMDB file management CLI supporting various operations on MMDB database files"
  homepage "https://github.com/ipinfo/mmdbctl"
  url "https://ghfast.top/https://github.com/ipinfo/mmdbctl/archive/refs/tags/mmdbctl-1.5.0.tar.gz"
  sha256 "c4dd4faf93a824416e7bb8b9fb5d98b6bf0aa851a01122035081b82aed3f2f8d"
  license "Apache-2.0"
  head "https://github.com/ipinfo/mmdbctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b0d316d87e3a885585af3c277cd07fea69ce401448437c08b755a8b7df92547b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b0d316d87e3a885585af3c277cd07fea69ce401448437c08b755a8b7df92547b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b0d316d87e3a885585af3c277cd07fea69ce401448437c08b755a8b7df92547b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8989a5ff46f9614e4f55786bd95db6d51a0bf3d595e33d5e4b546fd4fb8ffb71"
    sha256 cellar: :any,                 x86_64_linux:      "afb62d9e1ae82e9d78940bf1612db56201815bc9b7e2ccda44ac77d632a5155a"
  end

  depends_on "go" => :build

  resource "test.mmdb", :test do
    url "https://ghfast.top/https://raw.githubusercontent.com/maxmind/MaxMind-DB/02de12f89048db626d04f8865c6fc76eac9a7a6b/test-data/GeoIP2-City-Test.mmdb"
    sha256 "df1eb8e048d3b2561f477cd27f7d642fc25a24767395071d782ae927036818a0"
  end

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args

    generate_completions_from_executable(bin/"mmdbctl", shell_parameter_format: :cobra)
  end

  test do
    testpath.install resource("test.mmdb")

    system bin/"mmdbctl", "verify", testpath/"GeoIP2-City-Test.mmdb"

    output = shell_output("#{bin}/mmdbctl metadata #{testpath}/GeoIP2-City-Test.mmdb")
    assert_match "GeoIP2 City Test Database (fake GeoIP2 data, for example purposes only)", output
  end
end